output "cluster_id" {
  description = "ID of the ECS cluster."
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "service_names" {
  description = "Names of ECS services."
  value = {
    for service, ecs_service in aws_ecs_service.services :
    service => ecs_service.name
  }
}

output "task_definition_arns" {
  description = "Task definition ARNs."
  value = {
    for service, task_definition in aws_ecs_task_definition.services :
    service => task_definition.arn
  }
}