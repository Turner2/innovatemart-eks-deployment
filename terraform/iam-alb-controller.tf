# Download IAM Policy for ALB Controller
data "http" "alb_controller_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.0/docs/install/iam_policy.json"
}

# Create IAM Policy
resource "aws_iam_policy" "alb_controller" {
  name        = "${local.cluster_name}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.http.alb_controller_iam_policy.response_body

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${local.cluster_name}-alb-controller-policy"
    Project     = "InnovateMart"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}

# IAM Role for ALB Controller (using EKS module's OIDC provider)
resource "aws_iam_role" "alb_controller" {
  name = "${local.cluster_name}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = {
    Name        = "${local.cluster_name}-alb-controller-role"
    Project     = "InnovateMart"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}

# Output the role ARN 
output "alb_controller_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}
