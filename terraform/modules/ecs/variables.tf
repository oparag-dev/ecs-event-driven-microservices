variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for dev ECS tasks."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for prod ECS tasks."
  default     = []
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether ECS tasks should receive public IPs."
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks."
  type        = string
}

variable "container_port" {
  description = "Port exposed by ECS containers."
  type        = number
}

variable "cpu" {
  description = "CPU units for each ECS task."
  type        = number
}

variable "memory" {
  description = "Memory in MB for each ECS task."
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks per service."
  type        = number
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN."
  type        = string
}

variable "order_task_role_arn" {
  description = "Task role ARN for the Order Service."
  type        = string
}

variable "notification_role_arn" {
  description = "Task role ARN for the Notification Service."
  type        = string
}

variable "ecr_repository_urls" {
  description = "Map of service names to ECR repository URLs."
  type        = map(string)
}

variable "cloudwatch_log_groups" {
  description = "Map of service names to CloudWatch log group names."
  type        = map(string)
}

variable "target_group_arns" {
  description = "Map of service names to ALB target group ARNs."
  type        = map(string)
}

variable "sqs_queue_url" {
  description = "SQS queue URL for order events."
  type        = string
}