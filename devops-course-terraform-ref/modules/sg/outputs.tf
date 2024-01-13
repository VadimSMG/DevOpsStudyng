#Вивід даних VPC ID сервера для приєднання до Security Group
output "sg_vpc_id" {
  description = "Server VPC ID"
  value = aws_security_group.this_sg.vpc_id
}
#Вивід даних Security Group ID
output "sg_id" {
  description = "Security Group ID"
  value = aws_security_group.this_sg.id
}
