#!/bin/bash
set -e

# Functions
apply_terraform() {
  echo "Initializing Terraform..."
  if [[ "$TF_BACKEND" == "S3" ]]; then
    terraform init -backend-config="bucket=${BUCKET_NAME}" \
                   -backend-config="key=devzero/terraform.tfstate" \
                   -backend-config="region=us-west-1"
  else
    terraform init
  fi
  echo "Applying Terraform configuration..."
  terraform apply -auto-approve
}

plan_terraform() {
  echo "Initializing Terraform..."
  if [[ "$TF_BACKEND" == "S3" ]]; then
    terraform init -backend-config="bucket=${BUCKET_NAME}" \
                   -backend-config="key=devzero/terraform.tfstate" \
                   -backend-config="region=us-west-1"
  else
    terraform init
  fi
  echo "Running Terraform plan..."
  terraform plan
}

cleanup() {
  echo "Destroying Terraform resources..."
  terraform destroy -auto-approve
  echo "Resources destroyed."
}

# Main logic
if [[ "$1" == "plan" ]]; then
  echo "Starting Terraform plan..."
  plan_terraform
elif [[ "$1" == "apply" ]]; then
  echo "Starting Terraform apply..."
  apply_terraform
elif [[ "$1" == "destroy" ]]; then
  echo "Starting Terraform destroy..."
  cleanup
else
  echo "Usage: $0 {plan|apply|destroy}"
  exit 1
fi
