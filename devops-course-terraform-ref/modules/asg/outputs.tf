#Вивід даних про ім'я Autoscaling Group
output "asg_name" {
  value = aws_autoscaling_group.this_asg.name
}
