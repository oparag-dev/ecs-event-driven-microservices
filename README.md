# ECS Event-Driven Microservices

This repository contains an AWS ECS-based event-driven microservices project. It is organized around four Python services, an Application Load Balancer, Amazon SQS, CloudWatch Logs, and Terraform-managed infrastructure.

## Repository Structure

```text
.
├── README.md
├── services
│   ├── user-service
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   ├── product-service
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   ├── order-service
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── notification-service
│       ├── app.py
│       ├── Dockerfile
│       └── requirements.txt
└── terraform
    ├── envs
    ├── modules
    └── root
```

## Services

- `user-service`: Manages user-related operations.
- `product-service`: Manages product-related operations.
- `order-service`: Handles order creation and coordinates event-driven workflows.
- `notification-service`: Handles asynchronous notifications triggered by events.

Each service is containerized independently and includes:

- `app.py`: Flask application entry point.
- `Dockerfile`: Container build definition.
- `requirements.txt`: Python dependencies.

## Architecture

```text
Client
  |
  v
Application Load Balancer
  |
  |-- /users/*          -> User Service
  |-- /products/*       -> Product Service
  |-- /orders/*         -> Order Service
  |-- /notifications/*  -> Notification Service
  |
  v
ECS Fargate Cluster
  |
  |-- User Service Task
  |-- Product Service Task
  |-- Order Service Task
  |-- Notification Service Task
  |
  v
Amazon SQS
  |
  v
Notification Service consumes order events

CloudWatch Logs captures logs per service.
Terraform manages all infrastructure.
```

The Application Load Balancer routes requests by path:

- `/users/*` routes to `user-service`.
- `/products/*` routes to `product-service`.
- `/orders/*` routes to `order-service`.
- `/notifications/*` routes to `notification-service`.

The `order-service` is expected to publish order events to Amazon SQS. The `notification-service` consumes those events and handles notification delivery.

## Run a Service Locally

From a service directory:

```bash
pip install -r requirements.txt
python app.py
```

The service listens on port `5000` by default. Override the port with:

```bash
PORT=5001 python app.py
```

## Build a Service Image

From a service directory:

```bash
docker build -t user-service .
docker run -p 5000:5000 user-service
```

Replace `user-service` with the service you want to build.

## Infrastructure

Terraform files are organized under `terraform`:

- `terraform/root`: Root Terraform configuration.
- `terraform/modules`: Reusable infrastructure modules.
- `terraform/envs`: Environment-specific variable files.

Expected infrastructure modules include ECS, ECR, ALB, SQS, IAM, VPC, CloudWatch, and security groups.

## Terraform Workflow

From the Terraform root directory:

```bash
cd terraform/root
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=../envs/dev.tfvars
terraform apply -var-file=../envs/dev.tfvars
```

To destroy the development environment:

```bash
terraform destroy -var-file=../envs/dev.tfvars
```

## Current Status

The repository currently contains the service skeleton and Terraform layout. Service logic, event contracts, queues, and infrastructure definitions still need to be completed.
