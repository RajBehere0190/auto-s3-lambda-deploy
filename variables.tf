variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for EC2 instance (without .pem)"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for static website"
  type        = string
}
