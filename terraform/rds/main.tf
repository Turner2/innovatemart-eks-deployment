# Security Group for RDS - Allow access from VPC CIDR
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# PostgreSQL RDS for Orders Service
resource "aws_db_instance" "orders_postgres" {
  identifier             = "${var.project_name}-orders-pg"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "orders"
  username               = "orders_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "${var.project_name}-orders-postgres"
  }
}

# MySQL RDS for Catalog Service
resource "aws_db_instance" "catalog_mysql" {
  identifier             = "${var.project_name}-catalog-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "catalog"
  username               = "catalog_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "${var.project_name}-catalog-mysql"
  }
}

# DynamoDB Table for Carts Service
resource "aws_dynamodb_table" "carts" {
  name           = "${var.project_name}-carts"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-carts-dynamodb"
  }
}

# Outputs
output "orders_pg_endpoint" {
  value       = aws_db_instance.orders_postgres.endpoint
  description = "PostgreSQL endpoint for orders service"
}

output "catalog_mysql_endpoint" {
  value       = aws_db_instance.catalog_mysql.endpoint
  description = "MySQL endpoint for catalog service"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.carts.name
  description = "DynamoDB table name for carts service"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.carts.arn
  description = "DynamoDB table ARN for IAM policies"
}
