# auto-s3-lambda-deploy
# Terraform Lambda S3 EC2 Setup

This project automates the deployment of an EC2 instance, an S3 bucket for static website hosting, and a Lambda function that logs S3 events.

## Prerequisites
- AWS Account
- Terraform
- AWS CLI configured
- EC2 Key Pair

## Steps for Setup
1. Clone the repository.
2. Run `terraform init` to initialize.
3. Run `terraform apply` to deploy the resources.

## Lambda Function
This Lambda function is triggered on S3 object creation events. It logs the event details to CloudWatch.

## Troubleshooting
- Lambda not triggering: Check S3 bucket permissions.
- CloudWatch logs empty: Check Lambda IAM permissions.

## Future Improvements
- Automate Lambda function deployment via Terraform.
- Add support for more S3 event triggers.
