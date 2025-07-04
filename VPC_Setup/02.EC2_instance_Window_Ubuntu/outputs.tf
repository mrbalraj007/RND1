# Ubuntu Server Outputs
output "demoserver_public_ip" {
  value       = aws_instance.demoserver-svr.public_ip
  description = "Public IP of the Ubuntu demo server"
}

output "demoserver_private_ip" {
  value       = aws_instance.demoserver-svr.private_ip
  description = "Private IP of the Ubuntu demo server"
}

output "demoserver_id" {
  value       = aws_instance.demoserver-svr.id
  description = "Instance ID of the Ubuntu demo server"
}

output "demoserver_dns" {
  value       = aws_instance.demoserver-svr.public_dns
  description = "Public DNS name of the Ubuntu demo server"
}

# Windows Server Outputs
output "windows_server_public_ip" {
  value       = aws_instance.windows-server.public_ip
  description = "Public IP of the Windows server"
}

output "windows_server_private_ip" {
  value       = aws_instance.windows-server.private_ip
  description = "Private IP of the Windows server"
}

output "windows_server_id" {
  value       = aws_instance.windows-server.id
  description = "Instance ID of the Windows server"
}

output "windows_server_dns" {
  value       = aws_instance.windows-server.public_dns
  description = "Public DNS name of the Windows server"
}

output "windows_administrator_password" {
  value       = rsadecrypt(aws_instance.windows-server.password_data, file("${var.key_name}.pem"))
  description = "Administrator password for Windows server (requires private key)"
  sensitive   = true
}

# Service URLs
output "sonarqube_url" {
  value       = "http://${aws_instance.demoserver-svr.public_ip}:9000"
  description = "SonarQube access URL (Ubuntu server)"
}

output "windows_rdp_connection" {
  value       = "${aws_instance.windows-server.public_ip}:3389"
  description = "RDP connection string for Windows server"
}

# Infrastructure Info
output "vpc_id" {
  value       = data.aws_vpc.demo_ecs_vpc.id
  description = "VPC ID where the instances are deployed"
}

output "subnet_id" {
  value       = data.aws_subnets.public_subnets.ids[0]
  description = "Subnet ID where the Ubuntu instance is deployed"
}
