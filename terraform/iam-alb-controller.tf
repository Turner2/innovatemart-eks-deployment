# Download IAM Policy for ALB Controller
data "http" "alb_controller_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.0/docs/install/iam_policy.json"
}

# Create IAM Policy
resource "aws_iam_policy" "alb_controller" {
  name        = "${var.cluster_name}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.http.alb_controller_iam_policy.response_body
}

# Get OIDC provider
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# IAM Role for ALB Controller
resource "aws_iam_role" "alb_controller" {
  name = "${var.cluster_name}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.cluster.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}

# Output the role ARN
output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller.arn
}
