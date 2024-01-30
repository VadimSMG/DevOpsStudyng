#Змінна для отримання значення AMI
variable "aws_ami" {
  description = "Chosed AMI"
  type = string
}
#Змінна для отримання ID Security Group
variable "sg-id" {
  description = "Security Group ID for instance"
  type = string
}
