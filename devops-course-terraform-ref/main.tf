terraform {
  required_providers {
    #Провайдер для сервісу AWS 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    #Провайдер для створення випадкових паролей
    random = {
      source = "hashicorp/random"
    }
    #Ресурси для сервісу Docker
    /*    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }*/
  }
  required_version = ">= 1.2.0"
  #Конфігурація для викристання існуючого Remote State S3 bucket разом з EC2. У цьому розділі використання змінних не допускається.
  backend "s3" {
    bucket = "dev-stud-buck"
    key    = "this_key.tfstate"
    region = "us-west-2"
  }
}
#Параметри провайдеру AWS
provider "aws" {
  region = var.aws_region
}
#Використання звонішнього модулю з налаштуваннями EC2
module "ec2_module" {
  source = "./modules/ec2"
}
#Використання зовнішнього модуля налаштувань Classic Load Balancer
module "elb_module" {
  source = "./modules/elb"
}
#Зовнішній модуль генерації випадкого паролю
/*module "rnd_pwd_module" {
  source = "./modules/rnd-pwd"
}*/
#Ресурс для прив'язування EC2 до Classic elb
resource "aws_elb_attachment" "this_attachment" {
  elb      = module.elb_module.elb_name
  instance = module.ec2_module.aws_instance_id
}
#Рерурс для прив'язування EC2 до ціьової групи Load Balancer
/*resource "aws_lb_target_group_attachment" "this_attachment" {
  target_group_arn = module.elb_module.elb_arn
  target_id        = module.ec2_module.aws_instance_id
}*/
#Використання параметру data для отримання інформації про поточний (current) аккаунт AWS 
data "aws_caller_identity" "current" {}
#Отримання інформації про всі VPC
#data "aws_vpc" "this_vpc" {}
#Налаштування внутрішнього ресурсу random_password для генерації паролю
/*resource "random_password" "my-test-password" {
  length           = 18      #Довжина паролю
  special          = true    #Додавання спеціальних символів
  upper            = true    #Додавання символів верхнього регістру
  numeric          = true    #Додавання цифр
  min_upper        = 2       #Мінімальна кількість символів верхнього регістру
  min_numeric      = 2       #Мінімальна кількість цифр
  min_special      = 2       #Мінімальна кількість спеціальних символів
  override_special = "!@#$%" #Перевизначення вказаних спеціальних символів
}*/
#Створення секрету за допомогою ресусру AWS Sectret Manager
/*resource "aws_secretsmanager_secret" "my-test-secret" {
  name = "my-test-secret"
}
#Додавання версії секрету для згенерованого паролю
resource "aws_secretsmanager_secret_version" "my-test-secret-version" {
  secret_id = aws_secretsmanager_secret.my-test-secret.id
  #Використання jsonencode дозволяє конвертувати об'єкт у JSON строку
  secret_string = jsonencode({
    #Значення random_password.my-test-password.result - це значення паролю, згенерованого ресурсом random_password
    password = module.rnd_pwd_module.secret_pwd
  })
}*/
#Зовнішній модуль для налаштування Security Group
/*module "sg_module" {
  source = "./modules/sg/"
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

