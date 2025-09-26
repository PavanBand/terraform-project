Step-by-Step: Deploy Terraform Project on AWS EC2
1️⃣ Launch an EC2 instance

Use Amazon Linux 2 AMI.

Type: t2.micro or t3.micro.

Key pair: default-aws-1 (or your own key).

Security group: Allow SSH (22), HTTP (if needed), and any ports for your services.

2️⃣ Connect to EC2 via SSH

On your local machine:

ssh -i "default-aws-1.pem" ec2-user@<EC2-Public-IP>


Replace <EC2-Public-IP> with the public IP of your instance.

3️⃣ Update EC2 and install required tools
sudo yum update -y
sudo yum install -y git unzip zip curl

4️⃣ Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -v  # Verify installation

5️⃣ Clone your GitHub repo
cd ~
git clone https://github.com/PavanBand/terraform-project.git
cd terraform-project/terraform-iac-assignment

6️⃣ Prepare Lambda ZIP file

Go to the Lambda code folder and ensure the deployment package exists:

cd lambda-code
zip -r lambda_function.zip .


If you already have lambda_function.zip, you can skip the zip command.

7️⃣ Upload Lambda ZIP to S3

Check terraform.tfvars for bucket name:

aws s3 cp lambda_function.zip s3://iac-lambda-deployment-342593763660-20250925/lambda_function.zip


Verify upload:

aws s3 ls s3://iac-lambda-deployment-342593763660-20250925/

8️⃣ Initialize Terraform

Go back to your Terraform root:

cd ~/terraform-project/terraform-iac-assignment
terraform init

9️⃣ Plan Terraform

Check what Terraform will create:

terraform plan


Ensure the output shows the resources that will be created.

🔟 Apply Terraform

Deploy all resources:

terraform apply -auto-approve


Wait until all resources are created successfully.

Check outputs for VPC, ECS, and Lambda info.

1️⃣1️⃣ Verify in AWS Console

Go to EC2 → check ECS instances.

Go to ECS → cluster should be visible.

Go to Lambda → function should exist.

Go to VPC → subnets and IGW should exist.

1️⃣2️⃣ Optional: Clean up

If you ever want to destroy everything:

terraform destroy -auto-approve
