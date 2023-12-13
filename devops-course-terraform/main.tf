terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

#Створення пари ключів для доступу через SSH
resource "aws_key_pair" "dev_ops_test" {
  key_name = "test-key-pair"
  public_key = file("/home/vad/Документи/DevOpsCurse/devops-course-terraform/dev-test.pub")
}

#Створення EC2 instance за допомогою AWS
resource "aws_instance" "dev_ops_test" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "DevOpsLearning"
  }
}

#Інтеграція Docker на EC2 instance
provider "docker" {}

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
}


output "dev_ops_test_instance_ip" {
  value = aws_instance.dev_ops_test.public_ip
}
