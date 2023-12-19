output "dev_ops_instance_ip" {
  description = "Showing public IP of instance"
  value       = try(resource.aws_instance.dev_ops_test.public_ip)
}
output "aws_account_id" {
  description = "Showing AWS ID of current account"
  value       = data.aws_caller_identity.current.account_id
}
