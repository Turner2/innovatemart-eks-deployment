# Developer IAM User
resource "aws_iam_user" "developer" {
  name = "innovatemart-developer-readonly"
  path = "/developers/"

  tags = {
    Description = "Read-only developer access to EKS cluster"
  }
}

# Developer Access Keys
resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

# IAM Policy for EKS Read-Only Access
resource "aws_iam_policy" "eks_readonly" {
  name        = "EKSReadOnlyAccess"
  description = "Read-only access to EKS cluster resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to developer user
resource "aws_iam_user_policy_attachment" "developer_eks_readonly" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.eks_readonly.arn
}

# Kubernetes ConfigMap for AWS Auth
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = aws_iam_user.developer.arn
        username = "developer-readonly"
        groups   = ["readonly-group"]
      }
    ])
  }

  force = true
}

# Kubernetes ClusterRole for Read-Only Access
resource "kubernetes_cluster_role" "readonly" {
  metadata {
    name = "readonly-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "namespaces", "nodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list"]
  }
}

# Kubernetes ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "readonly" {
  metadata {
    name = "readonly-cluster-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.readonly.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "readonly-group"
    api_group = "rbac.authorization.k8s.io"
  }
}
