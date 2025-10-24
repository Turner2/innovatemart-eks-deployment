# Get AWS account ID
data "aws_caller_identity" "current" {}

# IAM Role for Carts Service to access DynamoDB
resource "aws_iam_role" "carts_dynamodb" {
  name = "${var.cluster_name}-carts-dynamodb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(module.eks.cluster_endpoint, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(module.eks.cluster_endpoint, "https://", "")}:sub" = "system:serviceaccount:retail-store:carts"
          "${replace(module.eks.cluster_endpoint, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

# IAM Policy for DynamoDB access
resource "aws_iam_role_policy" "carts_dynamodb" {
  name = "carts-dynamodb-access"
  role = aws_iam_role.carts_dynamodb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ]
      Resource = module.rds.dynamodb_table_arn
    }]
  })
}

output "carts_role_arn" {
  value = aws_iam_role.carts_dynamodb.arn
}

