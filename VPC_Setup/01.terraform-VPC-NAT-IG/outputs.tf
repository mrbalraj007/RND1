output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.demo_ecs_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.demo_ecs_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.demo_ecs_igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.demo_ecs_nat.id
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = data.aws_availability_zones.available.names
}
