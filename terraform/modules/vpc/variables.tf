variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
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

variable "enable_private_networking" {
  type        = bool
  description = "Whether to create private subnets and NAT Gateway."
  default     = false
}

variable "availability_zones" {
  description = "Availability zones for public subnets."
  type        = list(string)
}

