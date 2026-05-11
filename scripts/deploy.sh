#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_ROOT="$PROJECT_ROOT/terraform/root"
VAR_FILE="../envs/dev.tfvars"

AWS_REGION="eu-west-3"
ENVIRONMENT="dev"
PROJECT_NAME="ecs-event-ms"

SERVICES=(
  "user-service"
  "product-service"
  "order-service"
  "notification-service"
)

echo "=========================================="
echo " Deploying DEV environment"
echo " Project: ecs-event-driven-microservices"
echo " Region: $AWS_REGION"
echo "=========================================="
echo

echo "Step 1: Applying Terraform infrastructure..."
cd "$TERRAFORM_ROOT"
terraform init
terraform apply -var-file="$VAR_FILE"

echo
echo "Step 2: Preparing ECR login..."
cd "$PROJECT_ROOT"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo
echo "Step 3: Building and pushing service images..."

for SERVICE in "${SERVICES[@]}"; do
  REPO_NAME="${PROJECT_NAME}-${ENVIRONMENT}-${SERVICE}"
  IMAGE_URI="${ECR_REGISTRY}/${REPO_NAME}:latest"

  echo
  echo "Building $SERVICE..."
  docker build --no-cache -t "${SERVICE}:latest" "$PROJECT_ROOT/services/${SERVICE}"

  echo "Tagging $SERVICE as $IMAGE_URI..."
  docker tag "${SERVICE}:latest" "$IMAGE_URI"

  echo "Pushing $IMAGE_URI..."
  docker push "$IMAGE_URI"

  echo "$SERVICE pushed successfully."
done

echo
echo "Step 4: Forcing ECS services to pull the latest images..."

for SERVICE in "${SERVICES[@]}"; do
  ECS_SERVICE_NAME="${PROJECT_NAME}-${ENVIRONMENT}-${SERVICE}"

  echo "Redeploying $ECS_SERVICE_NAME..."

  aws ecs update-service \
    --cluster "${PROJECT_NAME}-${ENVIRONMENT}-cluster" \
    --service "$ECS_SERVICE_NAME" \
    --force-new-deployment \
    --region "$AWS_REGION" \
    --query "service.{name:serviceName,status:status,desired:desiredCount,running:runningCount,pending:pendingCount}" \
    --output table
done

echo
echo "Step 5: Deployment summary"
cd "$TERRAFORM_ROOT"

ALB_DNS=$(terraform output -raw alb_dns_name)

echo
echo "ALB DNS:"
echo "http://$ALB_DNS"
echo
echo "Health check commands:"
echo "curl http://$ALB_DNS/users/health"
echo "curl http://$ALB_DNS/products/health"
echo "curl http://$ALB_DNS/orders/health"
echo "curl http://$ALB_DNS/notifications/health"
echo
echo "Order event test:"
echo "curl -X POST http://$ALB_DNS/orders"
echo
echo "DEV deployment completed."
