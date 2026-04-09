output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.runner.id
}

output "instance_public_dns" {
  description = "Public DNS hostname of the EC2 instance"
  value       = aws_instance.runner.public_dns
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.runner.public_ip
}

output "security_group_id" {
  description = "ID of the security group attached to the runner"
  value       = aws_security_group.runner.id
}
