output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

# FIX: Use the standard map output for Node Group ARNs
output "node_group_arn" {
  description = "The ARN of the EKS node group"
  value       = module.eks.node_group_arns["main"]
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "developer_user_name" {
  description = "Developer IAM user name"
  value       = module.iam.developer_user_name
}

output "developer_access_key_id" {
  description = "Developer access key ID"
  value       = module.iam.developer_access_key_id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Developer secret access key"
  value       = module.iam.developer_secret_access_key
  sensitive   = true
}
