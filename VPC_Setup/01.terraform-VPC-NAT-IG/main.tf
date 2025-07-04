# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "demo_ecs_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    Project     = "Demo-ECS-Project"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "demo_ecs_igw" {
  vpc_id = aws_vpc.demo_ecs_vpc.id

  tags = {
    Name        = "${var.vpc_name}-IGW"
    Environment = var.environment
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.demo_ecs_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-Public-Subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.demo_ecs_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.vpc_name}-Private-Subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.vpc_name}-NAT-EIP"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.demo_ecs_igw]
}

# Create NAT Gateway (in first AZ only)
resource "aws_nat_gateway" "demo_ecs_nat" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name        = "${var.vpc_name}-NAT-Gateway"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.demo_ecs_igw]
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.demo_ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ecs_igw.id
  }

  tags = {
    Name        = "${var.vpc_name}-Public-RT"
    Environment = var.environment
  }
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.demo_ecs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_ecs_nat.id
  }

  tags = {
    Name        = "${var.vpc_name}-Private-RT"
    Environment = var.environment
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Create VPC Endpoint for S3 (Gateway type)
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.demo_ecs_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id, aws_route_table.public_route_table.id]

  tags = {
    Name        = "${var.vpc_name}-S3-VPC-Endpoint"
    Environment = var.environment
  }
}
