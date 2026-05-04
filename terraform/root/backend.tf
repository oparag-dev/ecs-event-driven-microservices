terraform {
  backend "s3" {
    bucket       = "ecs-event-terraform-state-unique"
    key          = "ecs-event-driven-microservices/dev/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    use_lockfile = true
  }
}