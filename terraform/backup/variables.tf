variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Use your live VPC and subnets so TF doesn't try to recreate them
variable "existing_vpc_id" {
  type    = string
  default = "vpc-06739db3d5c7f9b6f"
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["subnet-037be9c6b47303ee8", "subnet-06c3930382a8ff7d0"]
}

# CIDR for the VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "db_password" {
  description = "Password for managed databases, sourced from terraform.tfvars"
  type        = string
  sensitive   = true
}
