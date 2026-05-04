output "queue_id" {
  description = "ID of the SQS queue."
  value       = aws_sqs_queue.order_events.id
}

output "queue_url" {
  description = "URL of the SQS queue."
  value       = aws_sqs_queue.order_events.url
}

output "queue_arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.order_events.arn
}

output "queue_name" {
  description = "Name of the SQS queue."
  value       = aws_sqs_queue.order_events.name
}