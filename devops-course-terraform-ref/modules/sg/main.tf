#Отримання інформації про всі VPC
data "aws_vpc" "this_vpc" {}
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
