output "elb_name" {
  description = "The Classic ELB name for attachment to EC2"
  value = aws_elb.this_elb.name
} 
