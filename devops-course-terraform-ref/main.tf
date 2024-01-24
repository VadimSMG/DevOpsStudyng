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
#Використання зовнішнього модулю створення Security Group
/*module "sg_module" {
  source = "./modules/sg"
}*/
data "aws_vpc" "this_vpc" {}

resource "aws_security_group" "this_sg" {
  name        = "this-sg"
  description = "Security for Test"
  vpc_id      = data.aws_vpc.this_vpc.id
  #security_group_id = "sg-0734a5b35ead8d089"

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
#Використання зовнішнього модулю з налаштуваннями EC2
module "ec2_module" {
  source = "./modules/ec2"
  #Передавання Input Variable у модуль
  sg_id  = aws_security_group.this_sg.id
}
/*#Використання зовнішнього модуля налаштувань Classic Load Balancer
module "elb_module" {
  source = "./modules/elb"
  sg_id  = aws_security_group.this_sg.id
}*/
#Модуль для Application Load Balancer
module "alb_module" {
  source = "./modules/alb"
  sg-id = aws_security_group.this_sg.id
  vpc-id = data.aws_vpc.this_vpc.id
}
#Модуль для бази даних RDS
module "db_module" {
  source = "./modules/rds"
}
#Зовнішній модуль генерації випадкого паролю
/*module "rnd_pwd_module" {
  source = "./modules/rnd-pwd"
}*/

#Ресурс для прив'язування EC2 до Classic elb
/*resource "aws_elb_attachment" "this_attachment" {
  elb      = module.elb_module.elb_name
  instance = module.ec2_module.aws_instance_id
}*/
#Рерурс для прив'язування EC2 до ціьової групи Load Balancer
resource "aws_lb_target_group_attachment" "this_attachment" {
  #Прив'язування EC2 до модулю Classic LB
  #  target_group_arn = module.elb_module.elb_arn
  #Прив'язування EC2 до модулю Application LB
  target_group_arn = module.alb_module.app_tg_arn
  target_id        = module.ec2_module.aws_instance_id
}
#Використання параметру data для отримання інформації про поточний (current) аккаунт AWS 
data "aws_caller_identity" "current" {}
#Отримання інформації про всі VPC
#data "aws_vpc" "this_vpc" {}
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

