#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="eu-west-3"
ENVIRONMENT="dev"
PROJECT_NAME="ecs-event-ms"

SERVICES=(
  "user-service"
  "product-service"
  "order-service"
  "notification-service"
)

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

for SERVICE in "${SERVICES[@]}"; do
  REPO_NAME="${PROJECT_NAME}-${ENVIRONMENT}-${SERVICE}"
  IMAGE_URI="${ECR_REGISTRY}/${REPO_NAME}:latest"

  echo "Building ${SERVICE}..."
  docker build -t "${SERVICE}:latest" "./services/${SERVICE}"

  echo "Tagging ${SERVICE} as ${IMAGE_URI}..."
  docker tag "${SERVICE}:latest" "${IMAGE_URI}"

  echo "Pushing ${IMAGE_URI}..."
  docker push "${IMAGE_URI}"

  echo "${SERVICE} pushed successfully."
done

echo "All service images pushed to ECR."
