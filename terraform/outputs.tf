output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "vpc_id" {
  value = var.existing_vpc_id
}

output "private_subnets" {
  value = var.private_subnet_ids
}

