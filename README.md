# Step 1: Go to your project directory
cd ~/terraform-project/terraform-iac-assignment

# Step 2: Initialize Terraform (install providers and modules)
terraform init

# Step 3: Format Terraform files
terraform fmt

# Step 4: Validate Terraform configuration
terraform validate

# Step 5: Create EC2 key pair (replace with your name)
aws ec2 create-key-pair --key-name default-aws-1 --query 'KeyMaterial' --output text > default-aws-1.pem

# Step 6: Set permissions for key pair
chmod 400 default-aws-1.pem

# Step 7: Edit terraform.tfvars with your custom values
nano terraform.tfvars
# - aws_region = "us-east-1"
# - environment = "dev"
# - lambda_s3_bucket = "pavan-iac-lambda-bucket-12345"
# - key_name = "default-aws-1"

# Step 8: Prepare Lambda deployment package
cd lambda-code
zip lambda_function.zip lambda_function.py
cd ..

# Step 9: Upload Lambda code to S3
aws s3 cp lambda-code/lambda_function.zip s3://pavan-iac-lambda-bucket-12345/

# Step 10: Check if Lambda code is uploaded
aws s3 ls s3://pavan-iac-lambda-bucket-12345/

# Step 11: Plan Terraform deployment
terraform plan

# Step 12: Apply Terraform configuration
terraform apply
# Enter 'yes' when prompted

# Step 13: Verify ECS cluster and Lambda function creation
# ECS
aws ecs list-clusters --region us-east-1
aws ecs describe-clusters --clusters iac-assignment-cluster --region us-east-1

# Lambda
aws lambda list-functions --region us-east-1
aws lambda get-function --function-name iac-assignment-lambda --region us-east-1

# Step 14: Test Lambda function
aws lambda invoke \
  --function-name iac-assignment-lambda \
  --payload '{"test": "Hello from Terraform!"}' \
  response.json
cat response.json

# Step 15: Output resources from Terraform
terraform output

# Step 16: After testing, destroy infrastructure (optional)
terraform destroy
# Enter 'yes' when prompted

# Step 17: Push project to GitHub
git init
git add .
git commit -m "Initial commit - Terraform IaC project"
git branch -M main
git remote add origin https://github.com/PavanBand/terraform-iac-assignment.git
git push -u origin main
