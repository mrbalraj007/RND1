# Instance information outputs
output "instance_names" {
  description = "Names of the EC2 instances"
  value       = aws_instance.runner-svr[*].tags.Name
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.runner-svr[*].private_ip
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.runner-svr[*].public_ip
}

output "ssh_connection_commands" {
  description = "Commands to SSH into the instances"
  value       = [for instance in aws_instance.runner-svr : "ssh -i ${var.private_key_path} ubuntu@${instance.public_ip}"]
}
