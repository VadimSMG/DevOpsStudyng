terraform {
  required_providers {
    #Ресурси для сервісу AWS 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    #Ресурси для сервісу Docker
    /*    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }*/
  }
  required_version = ">= 1.2.0"
  #Конфігурація для викристання існуючого Remote State S3 bucket разом з EC2. У цьому модулі використання змінних не допускається.
  backend "s3" {
    bucket         = "dev-stud-buck"
    key            = "dev-stud-s3.tfstate"
    region         = "us-west-2"
    dynamodb_table = "dev-stud-table"
  }
}
#Параметри провайдеру AWS
provider "aws" {
  region = var.aws_region
}
#Провайдер для створення випадкових паролей
provider "random" {}
#Використання параметру data для отримання інформації про поточний (current) аккаунт AWS 
data "aws_caller_identity" "current" {}
#Отримання інформації про всі VPC
data "aws_vpc" "this_vpc" {}
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
#Створення секрету за допомогою ресусру AWS Sectret Manager
resource "aws_secretsmanager_secret" "my-test-secret" {
  name = "my-test-secret"
}
#Додавання версії секрету для згенерованого паролю
resource "aws_secretsmanager_secret_version" "my-test-secret-version" {
  secret_id = aws_secretsmanager_secret.my-test-secret.id
  #Використання jsonencode дозволяє конвертувати об'єкт у JSON строку
  secret_string = jsonencode({
    #Значення random_password.my-test-password.result - це значення паролю, згенерованого ресурсом random_password
    password = random_password.my-test-password.result
  })
}
#Створення EC2 instance за допомогою AWS
resource "aws_instance" "dev_ops_test" {
  ami                    = var.aws_ami
  instance_type          = var.aws_instance_type
  key_name               = "dev-test"
  vpc_security_group_ids = [aws_security_group.dev_ops_test.id]
  #Користувацький скрипт по встановленню та запуску Docker  
  user_data = file(var.docker_install_script)

  tags = {
    Name = "DevOpsLearning"
  }
}
#Налаштування вхідних та вихідних портів
resource "aws_security_group" "dev_ops_test" {
  name        = "test-security-group"
  description = "Security for Test"
  vpc_id      = data.aws_vpc.this_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Створення пари ключів для доступу через SSH
/*resource "aws_key_pair" "dev_ops_test" {
  key_name   = "test-key-pair"
  public_key = file(var.ssh_pub_key_path)
}*/
#Інтеграція Docker на EC2 instance та розгортання контейнеру серверу Nginx
/*provider "docker" {}

resource "docker_image" "nginx" {
  name 		= "nginx"
  keep_locally	= false
}

resource "docker_container" "nginx" {
  image 	= docker_image.nginx.image_id
  name		= "tutorial"

  ports {
	internal = 80
	external = 8000
  }
}*/

