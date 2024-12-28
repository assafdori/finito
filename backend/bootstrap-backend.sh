#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

BUCKET_NAME="technion-final-project"
STATE_FILE="terraform.tfstate"
STATE_FILE_PATH="./$STATE_FILE"
REMOTE_KEY="backend/terraform.tfstate"

# checking that the bucket exists
if ! aws s3 ls "s3://$BUCKET_NAME" > /dev/null 2>&1; then
    echo "Error: S3 bucket $BUCKET_NAME does not exist."
    exit 1
fi
echo "S3 bucket $BUCKET_NAME exists."

# pushing the state file to the bucket
echo "Uploading $STATE_FILE to S3 bucket $BUCKET_NAME..."

if ! aws s3 cp "$STATE_FILE_PATH" "s3://$BUCKET_NAME/$REMOTE_KEY" > /dev/null 2>&1; then
    echo "Error: Failed to upload $STATE_FILE to S3 bucket $BUCKET_NAME."
    echo "Possible reasons:"
    echo "- You do not have write permissions to the bucket."
    echo "- The bucket is misconfigured."
    echo "- The terraform.tfstate file is missing."
    exit 1
fi

echo "State file uploaded successfully."

# update the backend configuration in Terraform
echo "Updating backend configuration in Terraform..."
cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket         = "$BUCKET_NAME"
    key            = "$REMOTE_KEY"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
EOF

echo "Backend configuration updated."

echo "Reinitializing Terraform..."
terraform init -migrate-state

echo "Cleaning up local state file..."
mv "$STATE_FILE_PATH" "$STATE_FILE_PATH.local-backup"
echo "Cleanup complete."

echo "Backend migration complete!"
