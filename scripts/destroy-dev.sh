#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_ROOT="$PROJECT_ROOT/terraform/root"
VAR_FILE="../envs/dev.tfvars"

echo "=========================================="
echo " Destroying DEV infrastructure"
echo " Project: ecs-event-driven-microservices"
echo " Terraform root: $TERRAFORM_ROOT"
echo "=========================================="
echo

read -p "Are you sure you want to destroy the DEV environment? Type 'destroy-dev' to continue: " CONFIRMATION

if [ "$CONFIRMATION" != "destroy-dev" ]; then
  echo "Destroy cancelled."
  exit 1
fi

cd "$TERRAFORM_ROOT"

echo "Running terraform destroy..."
terraform destroy -var-file="$VAR_FILE"

echo
echo "DEV infrastructure destroy command completed."
