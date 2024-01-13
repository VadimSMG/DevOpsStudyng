#Змінна для визначення локації ELB
variable "az_elb" {
  description = "Availavbility Zones for AWS ELB"
  type = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
#Змінна для призначення ID для Security Group
variable "sg_id" {
  type = string 
}
