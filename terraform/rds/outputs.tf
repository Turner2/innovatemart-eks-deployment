output "orders_pg_endpoint" {
  description = "PostgreSQL endpoint for orders service"
  value       = aws_db_instance.orders_pg.endpoint
}

output "catalog_mysql_endpoint" {
  description = "MySQL endpoint for catalog service"
  value       = aws_db_instance.catalog_mysql.endpoint
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for carts service"
  value       = aws_dynamodb_table.carts.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN for carts service"
  value       = aws_dynamodb_table.carts.arn
}

output "rds_security_group_id" {
  description = "Security group ID for RDS instances"
  value       = aws_security_group.rds.id
}
