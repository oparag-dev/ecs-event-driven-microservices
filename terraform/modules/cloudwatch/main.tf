resource "aws_cloudwatch_log_group" "service_logs" {
  for_each = toset(var.services)

  name              = "/ecs/${var.project_name}/${var.environment}/${each.value}"
  retention_in_days = var.log_retention_days

  tags = {
    Name    = "${var.project_name}-${var.environment}-${each.value}-logs"
    Service = each.value
  }
}