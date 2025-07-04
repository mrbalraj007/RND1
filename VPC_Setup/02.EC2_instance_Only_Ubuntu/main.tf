# Data source to fetch the existing VPC
data "aws_vpc" "demo_ecs_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Data source to fetch public subnets from the VPC
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.demo_ecs_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}

# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Create single EC2 instance in the public subnet
resource "aws_instance" "demoserver-svr" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.demoserver-VM-SG.id]
  subnet_id                   = data.aws_subnets.public_subnets.ids[0] # Use first public subnet
  associate_public_ip_address = true
  user_data                   = templatefile("./demoserver_install.sh", {})

  tags = {
    Name        = "DevOps-Tools-Server"
    Environment = "demo"
    Project     = "Demo-ECS-Project"
  }

  root_block_device {
    volume_size = 20 # Increased for DevOps tools
    volume_type = "gp3"
  }
}

# Security group for DevOps tools server in the VPC
resource "aws_security_group" "demoserver-VM-SG" {
  name        = "DevOps-Tools-SG"
  description = "Security group for DevOps tools server"
  vpc_id      = data.aws_vpc.demo_ecs_vpc.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SonarQube port
  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Custom application ports
  ingress {
    description = "Custom Apps"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API server
  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.demo_ecs_vpc.cidr_block]
  }

  # Email ports
  ingress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTPS"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Development/testing port range
  ingress {
    description = "Development Ports"
    from_port   = 8000
    to_port     = 8999
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.demo_ecs_vpc.cidr_block]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "DevOps-Tools-SG"
    Environment = "demo"
    Project     = "Demo-ECS-Project"
  }
}

output "instance_ips" {
  value       = aws_instance.demoserver-svr.public_ip
  description = "The public IP of the DevOps tools server"
}

output "devops_server_ip" {
  value       = aws_instance.demoserver-svr.public_ip
  description = "Public IP of the DevOps tools server"
}