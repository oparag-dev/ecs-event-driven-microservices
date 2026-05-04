resource "aws_ecr_repository" "this" {
  for_each = toset(var.repositories)

  name = "${var.project_name}-${var.environment}-${each.value}"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name    = "${var.project_name}-${var.environment}-${each.value}"
    Service = each.value
  }
}