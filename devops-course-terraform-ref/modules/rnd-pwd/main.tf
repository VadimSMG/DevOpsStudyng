#Налаштування внутрішнього ресурсу random_password для генерації паролю
resource "random_password" "my-test-password" {
  length           = 18      #Довжина паролю
  special          = true    #Додавання спеціальних символів
  upper            = true    #Додавання символів верхнього регістру
  numeric          = true    #Додавання цифр
  min_upper        = 2       #Мінімальна кількість символів верхнього регістру
  min_numeric      = 2       #Мінімальна кількість цифр
  min_special      = 2       #Мінімальна кількість спеціальних символів
  override_special = "!@#$%" #Перевизначення вказаних спеціальних символів
}
