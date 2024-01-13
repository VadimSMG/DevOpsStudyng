#Вивід сгенерованого модулем паролю
output "secret_pwd" {
  value = random_password.my-test-password.result
}
