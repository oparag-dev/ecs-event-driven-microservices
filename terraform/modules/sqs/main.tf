resource "aws_sqs_queue" "order_events" {
  name = "${var.project_name}-${var.environment}-order-events"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 10

  tags = {
    Name = "${var.project_name}-${var.environment}-order-events"
  }
}