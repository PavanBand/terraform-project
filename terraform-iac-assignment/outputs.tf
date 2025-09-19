# Root module outputs

output "vpc_info" {
  description = "VPC information"
  value = {
    vpc_id            = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    internet_gateway_id = module.vpc.internet_gateway_id
  }
}

output "lambda_info" {
  description = "Lambda function information"
  value = {
    function_name = module.lambda.function_name
    function_arn  = module.lambda.function_arn
    role_arn      = module.lambda.lambda_role_arn
  }
}

output "ecs_info" {
  description = "ECS cluster information"
  value = {
    cluster_name       = module.ecs.cluster_name
    cluster_arn        = module.ecs.cluster_arn
    launch_template_id = module.ecs.launch_template_id
    security_group_id  = module.ecs.security_group_id
  }
}
