output "developer_user_name" {
  value = aws_iam_user.developer.name
}

output "developer_access_key_id" {
  value     = aws_iam_access_key.developer.id
  sensitive = true
}

output "developer_secret_access_key" {
  value     = aws_iam_access_key.developer.secret
  sensitive = true
}
