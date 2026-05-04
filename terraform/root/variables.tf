variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, staging, or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for public subnets."
  type        = list(string)
}

variable "enable_private_networking" {
  type        = bool
  description = "Whether to create private subnets and NAT Gateway for ECS tasks."
  default     = false
}

variable "container_port" {
  description = "Port exposed by the microservices containers."
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "CPU units for each ECS Fargate task."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MB for each ECS Fargate task."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks per service."
  type        = number
  default     = 1
}
#iam variables
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs."
  type        = number
  default     = 7
}
