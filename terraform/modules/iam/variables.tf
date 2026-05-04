variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue used for order events."
  type        = string
}