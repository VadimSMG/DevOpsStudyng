variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cidr_blocks" {
  description = "List of CIDR for securty group config"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "ssh_pub_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "/home/vad/Документи/DevOpsStudyng/devops-course-terraform-ref/dev-test.pub"
}

variable "aws_ami" {
  description = "AWS instance ami type"
  type        = string
  default     = "ami-830c94e3"
}

variable "aws_instance_type" {
  description = "AWS type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "docker_install_script" {
  description = "Path to Docker install script"
  type        = string
  default     = "/home/vad/Документи/DevOpsStudyng/devops-course-terraform-ref/docker_install.sh"
}
