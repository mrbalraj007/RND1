variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC to use"
  type        = string
  default     = "Demo-ECS-Project"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "MYLABKEY"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
