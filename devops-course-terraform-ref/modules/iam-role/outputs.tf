#Визначення зовнішніх параметрів для модуля iam-role
output "this_profile_name" {
  value = aws_iam_instance_profile.this_instance.name
}
