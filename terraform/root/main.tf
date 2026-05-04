# Root Terraform composition for the ECS event-driven microservices platform.

locals {
  services = {
    user-service = {
      path_pattern      = "/users/*"
      health_check_path = "/health"
    }

    product-service = {
      path_pattern      = "/products/*"
      health_check_path = "/health"
    }

    order-service = {
      path_pattern      = "/orders/*"
      health_check_path = "/health"
      publishes_events  = true
    }

    notification-service = {
      path_pattern      = "/notifications/*"
      health_check_path = "/health"
      consumes_events   = true
    }
  }

  service_names = keys(local.services)
}

module "vpc" {
  source = "../modules/vpc"

  project_name              = var.project_name
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  availability_zones        = var.availability_zones
  enable_private_networking = var.enable_private_networking
}

module "security_groups" {
  source = "../modules/security_groups"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "ecr" {
  source = "../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  repositories = local.service_names
}

module "sqs" {
  source = "../modules/sqs"

  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source = "../modules/iam"

  project_name  = var.project_name
  environment   = var.environment
  sqs_queue_arn = module.sqs.queue_arn
}

module "cloudwatch" {
  source = "../modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  services     = local.service_names
}

module "alb" {
  source = "../modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  container_port        = var.container_port
}

module "ecs" {
  source = "../modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  assign_public_ip   = var.enable_private_networking ? false : true

  ecs_security_group_id = module.security_groups.ecs_security_group_id
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count

  execution_role_arn    = module.iam.ecs_task_execution_role_arn
  order_task_role_arn   = module.iam.order_service_task_role_arn
  notification_role_arn = module.iam.notification_service_task_role_arn

  ecr_repository_urls   = module.ecr.repository_urls
  cloudwatch_log_groups = module.cloudwatch.log_group_names
  target_group_arns     = module.alb.target_group_arns
  sqs_queue_url         = module.sqs.queue_url
}