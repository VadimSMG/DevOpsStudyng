#Ресуср Terraform для імпорту налаштуання бази даних RDS. Значення параметрів отримуємо з деталей існуючої інфраструктури.
resource "aws_db_instance" "myapp_db" {
  allocated_storage = 20
  db_name = "myapp_db"
  engine = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t2.micro"
  username = "admin"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = "true"
  copy_tags_to_snapshot = true
  enabled_cloudwatch_logs_exports = [
    "audit",
  ]
  publicly_accessible = true
}
