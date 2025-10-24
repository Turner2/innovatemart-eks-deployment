terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "InnovateMart"
      ManagedBy   = "Terraform"
      Environment = "Production"
      Owner       = "Turner2"
      DeployDate  = "2025-10-24"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name = "innovatemart-eks-cluster"
  azs          = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project     = "InnovateMart"
    ManagedBy   = "Terraform"
    Environment = "Production"
    Owner       = "Turner2"
  }
}

# Reference the existing VPC instead of creating a new one
data "aws_vpc" "existing" {
  filter {
    name   = "vpc-id"
    values = ["vpc-06739db3d5c7f9b6f"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  # Use the existing VPC and hardcoded private subnets from the live cluster
  vpc_id     = data.aws_vpc.existing.id
  subnet_ids = ["subnet-037be9c6b47303ee8", "subnet-06c3930382a8ff7d0"]

  cluster_endpoint_public_access = true
  enable_irsa                    = true

  cluster_service_ipv4_cidr = "172.20.0.0/16"

  # Match the live cluster: Use existing IAM role (don't create new)
  create_iam_role = false
  iam_role_arn    = "arn:aws:iam::378388077304:role/innovatemart-eks-cluster-cluster-20251024080152839100000001"

  # Match the live cluster: Use existing KMS key (don't create new)
  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = "arn:aws:kms:us-east-1:378388077304:key/a38cece3-8361-452c-86d5-c2e518e3ea67"
    resources        = ["secrets"]
  }

  # Match the live cluster: Bootstrap permissions (set to true to match live)
  enable_cluster_creator_admin_permissions = true

  # Match the live cluster: Prevent bootstrap addons from forcing replacement
  bootstrap_self_managed_addons = false

  eks_managed_node_group_defaults = {
    cluster_version = "1.28"
  }

  eks_managed_node_groups = {
    main = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      cluster_version = "1.28"

      labels = {
        role        = "worker"
        environment = "production"
      }

      tags = merge(local.common_tags, { Name = "${local.cluster_name}-node" })
    }
  }

  tags = merge(local.common_tags, { Name = local.cluster_name })
}

