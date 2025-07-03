# Demo ECS Project VPC Infrastructure

This Terraform configuration creates a complete VPC infrastructure for the Demo ECS Project with the following components:

## Infrastructure Components

- **VPC**: `Demo-ECS-Project` with CIDR `10.0.0.0/16`
- **Subnets**: 
  - 2 Public subnets across 2 AZs (`10.0.1.0/24`, `10.0.2.0/24`)
  - 2 Private subnets across 2 AZs (`10.0.3.0/24`, `10.0.4.0/24`)
- **Gateways**:
  - Internet Gateway for public internet access
  - NAT Gateway in first AZ for private subnet internet access
- **VPC Endpoints**: S3 Gateway endpoint for efficient S3 access
- **DNS**: Enabled DNS hostnames and resolution

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- Appropriate AWS IAM permissions

## Deployment

1. Initialize Terraform:
```bash
cd terraform
terraform init
```

2. Review the plan:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

4. To destroy the infrastructure:
```bash
terraform destroy
```

## Outputs

The configuration provides outputs for:
- VPC ID and CIDR block
- Public and private subnet IDs
- Internet Gateway and NAT Gateway IDs
- S3 VPC Endpoint ID
- Availability zones used

## Customization

Modify `terraform.tfvars` to customize:
- AWS region
- VPC name and CIDR
- Subnet CIDRs
- Environment tags
