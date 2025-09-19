# Infrastructure as Code Assignment using Terraform

## Overview
This project demonstrates Infrastructure as Code (IaC) practices using Terraform to deploy a multi-tier AWS infrastructure including VPC, Lambda, and ECS components.

## Architecture
- **VPC Module**: Custom VPC with public subnets and internet gateway
- **Lambda Module**: AWS Lambda function with S3-based deployment
- **ECS Module**: ECS cluster with EC2 launch template and auto scaling

## Prerequisites
- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Terraform installed (version 1.0+)
- Basic knowledge of Terraform and AWS services

## Quick Start

### 1. Configure Variables
Update `terraform.tfvars` with your specific values:
```hcl
lambda_s3_bucket = "your-unique-bucket-name-12345"
key_name         = "your-ec2-key-pair"
```

### 2. Create EC2 Key Pair
```bash
aws ec2 create-key-pair --key-name your-ec2-key-pair --query 'KeyMaterial' --output text > your-ec2-key-pair.pem
chmod 400 your-ec2-key-pair.pem
```

### 3. Create Lambda Deployment Package
```bash
cd lambda-code
zip -r ../lambda_function.zip lambda_function.py requirements.txt
cd ..
```

### 4. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Apply configuration
terraform apply

# Upload Lambda code to S3
BUCKET_NAME=$(terraform output -json lambda_info | jq -r '.value.s3_bucket_name')
aws s3 cp lambda_function.zip s3://$BUCKET_NAME/

# Update Lambda function
aws lambda update-function-code \
  --function-name iac-assignment-lambda \
  --s3-bucket $BUCKET_NAME \
  --s3-key lambda_function.zip
```

### 5. Test Infrastructure
```bash
# Test Lambda function
aws lambda invoke \
  --function-name iac-assignment-lambda \
  --payload '{"test": "Hello from Terraform!"}' \
  response.json

cat response.json
```

### 6. Cleanup
```bash
terraform destroy
```

## Project Structure
```
terraform-iac-assignment/
├── main.tf                    # Root orchestration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars          # Variable values
├── providers.tf              # Provider config
├── lambda-code/              # Lambda source
│   ├── lambda_function.py
│   └── requirements.txt
└── modules/                  # Terraform modules
    ├── vpc/                  # VPC module
    ├── lambda/               # Lambda module
    └── ecs/                  # ECS module
```

## Key Features
- Modular Terraform architecture for reusability
- AWS best practices implementation
- Proper IAM roles and security groups
- S3-based Lambda deployment pattern
- Multi-AZ VPC design for high availability
- ECS cluster with auto scaling capabilities

## Troubleshooting
- Ensure S3 bucket names are globally unique
- Verify EC2 key pair exists in the correct region
- Check AWS credentials and permissions
- Review Terraform state for any conflicts

For detailed implementation guide, see the complete assignment documentation.
