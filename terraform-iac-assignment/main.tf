# Root module - Infrastructure as Code using Terraform
# This configuration orchestrates VPC, Lambda, and ECS modules

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "IaC-Assignment"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  environment         = var.environment
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name       = var.lambda_function_name
  lambda_s3_bucket   = var.lambda_s3_bucket
  lambda_s3_key      = var.lambda_s3_key
  lambda_runtime     = var.lambda_runtime
  lambda_handler     = var.lambda_handler
  environment        = var.environment

  depends_on = [module.vpc]
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  cluster_name        = var.ecs_cluster_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  key_name           = var.key_name
  instance_type      = var.instance_type
  environment        = var.environment

  depends_on = [module.vpc]
}
