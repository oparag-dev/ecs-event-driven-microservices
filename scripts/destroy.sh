#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_ROOT="$PROJECT_ROOT/terraform/root"
VAR_FILE="../envs/dev.tfvars"

AWS_REGION="eu-west-3"

ECR_REPOS=(
  "ecs-event-ms-dev-user-service"
  "ecs-event-ms-dev-product-service"
  "ecs-event-ms-dev-order-service"
  "ecs-event-ms-dev-notification-service"
)

echo "=========================================="
echo " Destroying DEV environment"
echo " Project: ecs-event-driven-microservices"
echo " Region: $AWS_REGION"
echo "=========================================="
echo

read -p "Type 'destroy-dev' to destroy the DEV environment: " CONFIRMATION

if [ "$CONFIRMATION" != "destroy-dev" ]; then
  echo "Destroy cancelled."
  exit 1
fi

echo
echo "Step 1: Cleaning ECR images..."

for repo in "${ECR_REPOS[@]}"; do
  echo
  echo "Checking ECR repository: $repo"

  if ! aws ecr describe-repositories \
    --repository-names "$repo" \
    --region "$AWS_REGION" >/dev/null 2>&1; then
    echo "Repository $repo does not exist. Skipping."
    continue
  fi

  aws ecr list-images \
    --repository-name "$repo" \
    --region "$AWS_REGION" \
    --query 'imageIds[*]' \
    --output json > /tmp/ecr-images.json

  if grep -q "imageDigest" /tmp/ecr-images.json; then
    echo "Deleting images in $repo..."

    aws ecr batch-delete-image \
      --repository-name "$repo" \
      --region "$AWS_REGION" \
      --image-ids file:///tmp/ecr-images.json >/dev/null

    echo "Images deleted from $repo."
  else
    echo "No images found in $repo."
  fi
done

rm -f /tmp/ecr-images.json

echo
echo "Step 2: Running Terraform destroy..."
cd "$TERRAFORM_ROOT"

terraform destroy -var-file="$VAR_FILE"

echo
echo "DEV environment destroyed."
