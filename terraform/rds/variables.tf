variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for security group rules"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "db_password" {
  description = "Master password for databases"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "innovatemart"
}

variable "cluster_name" {
  description = "EKS cluster name for tagging"
  type        = string
}
