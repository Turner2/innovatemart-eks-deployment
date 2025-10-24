<<<<<<< HEAD
# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

# EKS Outputs
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
=======
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
>>>>>>> cacc118033fc77e6c9df3de56e3c70c8cb541de3
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

<<<<<<< HEAD
# RDS Outputs - COMMENTED OUT
# output "orders_pg_endpoint" {
#   description = "PostgreSQL endpoint for orders service"
#   value       = module.rds.orders_pg_endpoint
# }

# output "catalog_mysql_endpoint" {
#   description = "MySQL endpoint for catalog service"
#   value       = module.rds.catalog_mysql_endpoint
# }

# output "dynamodb_table_name" {
#   description = "DynamoDB table name for carts"
#   value       = module.rds.dynamodb_table_name
# }

# output "dynamodb_table_arn" {
#   description = "DynamoDB table ARN for carts"
#   value       = module.rds.dynamodb_table_arn
# }
=======
output "cluster_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "vpc_id" {
  value = var.existing_vpc_id
}

output "private_subnets" {
  value = var.private_subnet_ids
}
>>>>>>> cacc118033fc77e6c9df3de56e3c70c8cb541de3
