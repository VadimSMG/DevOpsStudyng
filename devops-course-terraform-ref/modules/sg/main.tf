#Отримання інформації про всі VPC
data "aws_vpc" "this_vpc" {}
#Налаштування вхідних та вихідних портів
resource "aws_security_group" "this_sg" {
  name        = "this-sg"
  description = "Security for Test"
  vpc_id      = var.vpc_id 
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
