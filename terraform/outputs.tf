# EKS Cluster Outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

# RDS Outputs
output "orders_pg_endpoint" {
  description = "PostgreSQL endpoint for orders service"
  value       = module.rds.orders_pg_endpoint
}

output "catalog_mysql_endpoint" {
  description = "MySQL endpoint for catalog service"
  value       = module.rds.catalog_mysql_endpoint
}

# DynamoDB Outputs
output "dynamodb_table_name" {
  description = "DynamoDB table name for carts service"
  value       = module.rds.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN for carts service"
  value       = module.rds.dynamodb_table_arn
}

# Note: carts_role_arn and alb_controller_role_arn outputs are defined in:
# - iam-dynamodb.tf (carts_role_arn)
# - iam-alb-controller.tf (alb_controller_role_arn)

# Kubeconfig Command
output "kubeconfig_command" {
  description = "Command to update kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
