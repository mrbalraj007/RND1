output "demoserver_public_ip" {
  value       = aws_instance.demoserver-svr.public_ip
  description = "Public IP of the demo server"
}

output "demoserver_private_ip" {
  value       = aws_instance.demoserver-svr.private_ip
  description = "Private IP of the demo server"
}

output "demoserver_id" {
  value       = aws_instance.demoserver-svr.id
  description = "Instance ID of the demo server"
}

output "demoserver_dns" {
  value       = aws_instance.demoserver-svr.public_dns
  description = "Public DNS name of the demo server"
}

output "sonarqube_url" {
  value       = "http://${aws_instance.demoserver-svr.public_ip}:9000"
  description = "SonarQube access URL"
}

output "vpc_id" {
  value       = data.aws_vpc.demo_ecs_vpc.id
  description = "VPC ID where the instance is deployed"
}

output "subnet_id" {
  value       = data.aws_subnets.public_subnets.ids[0]
  description = "Subnet ID where the instance is deployed"
}
