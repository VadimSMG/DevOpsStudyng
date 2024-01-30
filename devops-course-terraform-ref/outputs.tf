/*output "dev_ops_instance_ip" {
  description = "Showing public IP of instance"
  value       = try(module.ec2_module.aws_instance)
}*/
output "aws_account_id" {
  description = "Showing AWS ID of current account"
  value       = data.aws_caller_identity.current.account_id
}
output "ags_name" {
  description = "Showing the Autoscaling Group name"
  value       = module.asg_module.asg_name
}
