variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "repositories" {
  description = "List of ECR repository names."
  type        = list(string)
}