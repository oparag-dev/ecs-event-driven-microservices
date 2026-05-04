locals {
  services = {
    user-service = {
      path_pattern = "/users*"
      health_path  = "/users/health"
      priority     = 10
    }

    product-service = {
      path_pattern = "/products*"
      health_path  = "/products/health"
      priority     = 20
    }

    order-service = {
      path_pattern = "/orders*"
      health_path  = "/orders/health"
      priority     = 30
    }

    notification-service = {
      path_pattern = "/notifications*"
      health_path  = "/notifications/health"
      priority     = 40
    }
  }
}

resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

resource "aws_lb_target_group" "services" {
  for_each = local.services

  name        = "${var.environment}-${replace(each.key, "-service", "")}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = each.value.health_path
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-${each.key}-tg"
    Service = each.key
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{\"message\":\"Route not found\"}"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "service_routes" {
  for_each = local.services

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}