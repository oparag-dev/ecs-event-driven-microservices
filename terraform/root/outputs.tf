output "project_name" {
  description = "Project name."
  value       = var.project_name
}

output "environment" {
  description = "Deployment environment."
  value       = var.environment
}

output "aws_region" {
  description = "AWS region."
  value       = var.aws_region
}

# VPC outputs
output "vpc_id" {
  description = "ID of the project VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

#security group outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = module.security_groups.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ID of the ECS tasks security group."
  value       = module.security_groups.ecs_security_group_id
}

#ecr outputs
output "ecr_repository_urls" {
  description = "Map of service names to ECR repository URLs."
  value       = module.ecr.repository_urls
}

output "ecr_repository_names" {
  description = "List of ECR repository names."
  value       = module.ecr.repository_names
}
#sqs outputs
output "sqs_queue_url" {
  description = "URL of the order events SQS queue."
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "ARN of the order events SQS queue."
  value       = module.sqs.queue_arn
}

output "sqs_queue_name" {
  description = "Name of the order events SQS queue."
  value       = module.sqs.queue_name
}
#iam outputs
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = module.iam.ecs_task_execution_role_arn
}

output "order_service_task_role_arn" {
  description = "ARN of the Order Service task role."
  value       = module.iam.order_service_task_role_arn
}

output "notification_service_task_role_arn" {
  description = "ARN of the Notification Service task role."
  value       = module.iam.notification_service_task_role_arn
}
#cloudwatch outputs
output "cloudwatch_log_group_names" {
  description = "Map of service names to CloudWatch log group names."
  value       = module.cloudwatch.log_group_names
}
#alb outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arns" {
  description = "Map of service names to ALB target group ARNs."
  value       = module.alb.target_group_arns
}
#ecs outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs.cluster_name
}

output "ecs_service_names" {
  description = "Names of ECS services."
  value       = module.ecs.service_names
}