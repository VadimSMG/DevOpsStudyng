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
}
#Параметри провайдеру AWS
provider "aws" {
  region = var.aws_region
}
#Налаштування вхідних та вихідних портів
resource "aws_security_group" "dev_ops_test" {
  name        = "test-secutity group"
  description = "Security for Test"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
}
#Створення пари ключів для доступу через SSH
resource "aws_key_pair" "dev_ops_test" {
  key_name   = "test-key-pair"
  public_key = file(var.ssh_pub_key_path)
}
#Створення EC2 instance за допомогою AWS
resource "aws_instance" "dev_ops_test" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  #Користувацький скрипт по встановленню та запуску Docker  
  user_data = file(var.docker_install_script)

  tags = {
    Name = "DevOpsLearning"
  }
}
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

