# Terraform variables file
# Customize these values for your environment

aws_region     = "us-east-1"
environment    = "dev"

# VPC Configuration
vpc_cidr               = "10.0.0.0/16"
availability_zones     = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]

# Lambda Configuration
lambda_function_name   = "iac-assignment-lambda"
lambda_s3_bucket      = "iac-lambda-deployment-342593763660-20250925"
lambda_s3_key         = "lambda_function.zip"
lambda_runtime        = "python3.9"
lambda_handler        = "lambda_function.lambda_handler"

# ECS Configuration
ecs_cluster_name      = "iac-assignment-cluster"
key_name              = "default-aws-1"
instance_type         = "t3.micro"
