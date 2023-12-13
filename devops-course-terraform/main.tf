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
  region = "us-west-2"
}
#Налаштування вхідних та вихідних портів
resource "aws_security_group" "dev_ops_test" {
  name         = "test-secutity group"
  description = "Security for Test"

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
resource "aws_key_pair" "dev_ops_test" {
  key_name   = "test-key-pair"
  public_key = file("/home/vad/Документи/DevOpsStudyng/devops-course-terraform/dev-test.pub")
}
#Створення EC2 instance за допомогою AWS
resource "aws_instance" "dev_ops_test" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  #Користувацький скрипт по встановленню та запуску Docker  
  user_data = <<-EOF
              #!bin/bash
              sudo apt-get update -y
              sudo apt-get install ca-certificates curl gnupg
              sudo install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              sudo chmod a+r /etc/apt/keyrings/docker.gpg
              echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
              sudo systemctl start docker
              EOF

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
#Налаштуання параметрів terraform output
output "dev_ops_test_instance_ip" {
  value = aws_instance.dev_ops_test.public_ip
}
