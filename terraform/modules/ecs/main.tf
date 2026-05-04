locals {
  services = {
    "user-service" = {
      container_name = "user-service"
      image_url      = "${var.ecr_repository_urls["user-service"]}:latest"
      task_role_arn  = null
      environment = [
        {
          name  = "SERVICE_NAME"
          value = "user-service"
        }
      ]
    }

    "product-service" = {
      container_name = "product-service"
      image_url      = "${var.ecr_repository_urls["product-service"]}:latest"
      task_role_arn  = null
      environment = [
        {
          name  = "SERVICE_NAME"
          value = "product-service"
        }
      ]
    }

    "order-service" = {
      container_name = "order-service"
      image_url      = "${var.ecr_repository_urls["order-service"]}:latest"
      task_role_arn  = var.order_task_role_arn
      environment = [
        {
          name  = "SERVICE_NAME"
          value = "order-service"
        },
        {
          name  = "SQS_QUEUE_URL"
          value = var.sqs_queue_url
        }
      ]
    }

    "notification-service" = {
      container_name = "notification-service"
      image_url      = "${var.ecr_repository_urls["notification-service"]}:latest"
      task_role_arn  = var.notification_role_arn
      environment = [
        {
          name  = "SERVICE_NAME"
          value = "notification-service"
        },
        {
          name  = "SQS_QUEUE_URL"
          value = var.sqs_queue_url
        }
      ]
    }
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster"
  }
}

resource "aws_ecs_task_definition" "services" {
  for_each = local.services

  family                   = "${var.project_name}-${var.environment}-${each.key}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = each.value.task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.value.container_name
      image     = each.value.image_url
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = each.value.environment

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloudwatch_log_groups[each.key]
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = each.key
        }
      }
    }
  ])

  tags = {
    Name    = "${var.project_name}-${var.environment}-${each.key}-task"
    Service = each.key
  }
}

resource "aws_ecs_service" "services" {
  for_each = local.services

  name            = "${var.project_name}-${var.environment}-${each.key}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.assign_public_ip ? var.public_subnet_ids : var.private_subnet_ids

    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arns[each.key]
    container_name   = each.value.container_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_ecs_task_definition.services
  ]

  tags = {
    Name    = "${var.project_name}-${var.environment}-${each.key}-service"
    Service = each.key
  }
}