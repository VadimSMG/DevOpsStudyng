output "elb_name" {
  description = "The Classic ELB name for attachment to EC2"
  value = aws_elb.this_elb.name
} 

output "sg_group" {
  description = "The SG created for ELB"
  value = aws_elb.this_elb.security_groups
}
