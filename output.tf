output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.static_website_bucket.id
}

output "s3_bucket_website_url" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
