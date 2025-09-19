# Lambda Module - Creates AWS Lambda function with S3 deployment

# Create S3 bucket for Lambda deployment packages
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.lambda_s3_bucket
  force_destroy = true

  tags = {
    Name = "${var.environment}-lambda-bucket"
  }
}

# Configure S3 bucket versioning
resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_pab" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.environment}-lambda-role"
  }
}

# Attach basic execution policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create Lambda function
resource "aws_lambda_function" "main" {
  function_name = var.function_name
  role         = aws_iam_role.lambda_role.arn
  handler      = var.lambda_handler
  runtime      = var.lambda_runtime

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = var.lambda_s3_key

  timeout = 30

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    Name = "${var.environment}-lambda-function"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_s3_bucket.lambda_bucket
  ]
}
