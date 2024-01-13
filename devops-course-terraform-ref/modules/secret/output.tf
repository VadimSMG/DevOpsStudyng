#Виведення значення секрету назовні модуля
output "secret_value" {
  value = aws_secretsmanager_secret_version.this-secret-version.secret_string
}
