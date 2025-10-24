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

<<<<<<< HEAD
  # Cluster access entry
  enable_cluster_creator_admin_permissions = true

  tags = merge(local.common_tags, {
    Name = local.cluster_name
  })
}

# RDS and DynamoDB Module - COMMENTED OUT FOR CLEAN DESTROY
# Uncomment after successful apply if needed
# module "rds" {
#   source = "./rds"
#   
#   cluster_name       = local.cluster_name
#   vpc_id             = module.vpc.vpc_id
#   vpc_cidr           = var.vpc_cidr
#   private_subnet_ids = module.vpc.private_subnets
#   db_password        = var.db_password
# }
=======
  tags = merge(local.common_tags, { Name = local.cluster_name })
}

>>>>>>> cacc118033fc77e6c9df3de56e3c70c8cb541de3

# Add this to the end of the eks module block
eks_managed_node_groups = {
  main = {
    instance_types = ["t3.medium"]
    min_size       = 2
    max_size       = 3
    desired_size   = 2
    launch_template = {
      user_data = base64encode(<<-EOT
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh innovatemart-eks-cluster --apiserver-endpoint https://86B9074BC596786B8F1006D00C653E1C.gr7.us-east-1.eks.amazonaws.com --b64-cluster-ca LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lIQjErVnRVb3JTaFF3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRFd01qUXhNREl5TlRsYUZ3MHpOVEV3TWpJeE1ESTNOVGxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURHSXpsS2RaYVZYNVV0WStrWmVhdjVmMm81QzJQOXBrdUhQTzY3Q1Bjdkd1VVlkc2NHUHJMdE9CS3EKeWlITkx1d0F5cnJlSWdrKzgyUU1EcVo4SGd1Q29KK1JqUld2VGd4L3NGV2hidE1lK3NEV1BLYXkvT2EyOTZzZQpRSHNNeWFYMFhLQlBoQXVMbHpUTVFoQUtnV1JZRmVHMkRMWVdZcUR1M3NtOVNoR1hVV3BoOFlNVy9NYm5RRGlRCmdPdzU1TUtEdExzNnQ3c29QREgyZVdXcnpyMDFubko5eS82d0RFeFRaYmRYeEc4YU9YN3JvbFVxTDh1OVp1akgKaDhMZFlPY2hDOHBYd1B1d1ZKYk9XL0huZTAyaW9DYmNEYUY2c1g2K2lzOTNJM3U2ZEt6RW9kc1FCdEtsMjd3eApjSllPRHZub0ZsTmhzU2lrRDl6aElidlJhRU9MQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTaC9PZmxxOU9JWnVYREQ4b1p3S2NwT0dsVDNqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQndScUZSL0habQpwNDRBQk0zSDhickdoOEwrM24yK3RIWHpWVjlKLCtrWnA4ZlBpUUxKWGEvSlk2Y0R5QVBGZFhSYVdzbDZJUTdHClZKUnRubWVSM3QxSm9NU1ozYWxwOTEwVW5oV2JwOVNWUmRBUzlndUc5cGZHQUhxSHFQRnlRY3JvanhNb1BqQ2cKbFFSbk5DM0Y1MVpzWVQ4KzlNU0pVanpEL29tNkpJNzBGamtHVm5WRWNFU3NuRXRrQXJ1K2JCZzUzU25mWllGeQp6SW1OcUd0VnM1SXNJWTBuc0hyOWcwY2dVaVlNWi94S3ppMFZmdkU1MndDNFQvQk15V3oyMU5LZ2ErZjNYMWliCm9XMEdTQy9MVi9xMzdrNGdjRUVCOGgvb1pRTndnNmVWT2dVZVNKRnVldkpySjQyYXFXV3BaWEpRUFhCc2t5WkUKQVVJS1ltRlNuVDdtCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K --kubelet-extra-args '--node-labels=role=worker'
EOT
              )
            }
          }
        }
      }
    }
  }
}
