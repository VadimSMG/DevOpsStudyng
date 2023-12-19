output "dev_ops_instance_ip" {
  description = "Showing public IP of instance"
  value = try(resource.aws_instance.dev_ops_test.public_ip)
}
