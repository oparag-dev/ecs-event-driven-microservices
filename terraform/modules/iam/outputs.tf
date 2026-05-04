output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution.name
}

output "order_service_task_role_arn" {
  description = "ARN of the Order Service ECS task role."
  value       = aws_iam_role.order_service_task.arn
}

output "order_service_task_role_name" {
  description = "Name of the Order Service ECS task role."
  value       = aws_iam_role.order_service_task.name
}

output "notification_service_task_role_arn" {
  description = "ARN of the Notification Service ECS task role."
  value       = aws_iam_role.notification_service_task.arn
}

output "notification_service_task_role_name" {
  description = "Name of the Notification Service ECS task role."
  value       = aws_iam_role.notification_service_task.name
}