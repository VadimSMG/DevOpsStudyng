#Змінна, що визначає AMI для інстансу, що буде орено. Впливає на тип ОС, що буде встановлено
variable "aws_ami" {
  description = "AWS instance ami type"
  type        = string
  default     = "ami-008fe2fc65df48dac"
}
#Змінна, що визначає тип інстансу. Впливає на апаратне забезпечення серверу
variable "aws_instance_type" {
  description = "AWS type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
#Змінна, що вказує шлях до користувацького скрипта. У цьому випадку це скрпт для встановлення Docker на Ubuntu Linux
variable "docker_install_script" {
  description = "Path to Docker install script"
  type        = string
  default     = "../../docker_install.sh"
}
