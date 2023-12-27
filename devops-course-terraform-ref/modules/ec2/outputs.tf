#Інформація, яка виводиться назовні модуля та може бути використана у основному модулі.
#Цей блок слугує для виведення Public IP створеного серверу
output "aws_instance" {
  value = aws_instance.dev_ops_test.public_ip
}
#Цей блок слугує для виведення ID для EC2 інстансу
output "aws_instance_id" {
  value = aws_instance.dev_ops_test.id
}
