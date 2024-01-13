#Зовнішній модуль генерації випадкого паролю
module "rnd_pwd_module" {
  source = "../rnd-pwd"
}
#Створення секрету за допомогою ресусру AWS Sectret Manager
resource "aws_secretsmanager_secret" "this-secret" {
  name = "this-secret"
}
#Додавання версії секрету для згенерованого паролю
resource "aws_secretsmanager_secret_version" "this-secret-version" {
  secret_id = aws_secretsmanager_secret.this-secret.id
  #Використання jsonencode дозволяє конвертувати об'єкт у JSON строку
  secret_string = jsonencode({
    #Значення random_password.my-test-password.result - це значення паролю, згенерованого ресурсом random_password
    password = module.rnd_pwd_module.secret_pwd
  })
}
