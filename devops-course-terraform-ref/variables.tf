#Змінна для визначення регіону розташування інстансу
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
#Змінна для визначення списку CIDR для групи безпеки
variable "cidr_blocks" {
  description = "List of CIDR for securty group config"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}
#Змінна, що містить шлях до файлу публічного SSH ключа
variable "ssh_pub_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "/home/vad/Документи/DevOpsStudyng/devops-course-terraform-ref/dev-test.pub"
}
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
  default     = "/home/vad/Документи/DevOpsStudyng/devops-course-terraform-ref/docker_install.sh"
}
