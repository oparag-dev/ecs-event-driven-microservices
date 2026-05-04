data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# -----------------------------
# ECS Task Execution Role
# Used by ECS to pull images from ECR and write logs to CloudWatch.
# -----------------------------
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-${var.environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------------
# Order Service Task Role
# Allows Order Service to publish order events to SQS.
# -----------------------------
resource "aws_iam_role" "order_service_task" {
  name               = "${var.project_name}-${var.environment}-order-service-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-order-service-task-role"
  }
}

data "aws_iam_policy_document" "order_service_sqs" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      var.sqs_queue_arn
    ]
  }
}

resource "aws_iam_policy" "order_service_sqs" {
  name        = "${var.project_name}-${var.environment}-order-service-sqs-policy"
  description = "Allows Order Service to send messages to the order events SQS queue."
  policy      = data.aws_iam_policy_document.order_service_sqs.json
}

resource "aws_iam_role_policy_attachment" "order_service_sqs" {
  role       = aws_iam_role.order_service_task.name
  policy_arn = aws_iam_policy.order_service_sqs.arn
}

# -----------------------------
# Notification Service Task Role
# Allows Notification Service to consume order events from SQS.
# -----------------------------
resource "aws_iam_role" "notification_service_task" {
  name               = "${var.project_name}-${var.environment}-notification-service-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-notification-service-task-role"
  }
}

data "aws_iam_policy_document" "notification_service_sqs" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [
      var.sqs_queue_arn
    ]
  }
}

resource "aws_iam_policy" "notification_service_sqs" {
  name        = "${var.project_name}-${var.environment}-notification-service-sqs-policy"
  description = "Allows Notification Service to consume messages from the order events SQS queue."
  policy      = data.aws_iam_policy_document.notification_service_sqs.json
}

resource "aws_iam_role_policy_attachment" "notification_service_sqs" {
  role       = aws_iam_role.notification_service_task.name
  policy_arn = aws_iam_policy.notification_service_sqs.arn
}