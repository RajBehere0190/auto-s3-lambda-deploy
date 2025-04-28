provider "aws" {
  region = var.aws_region
}

# 1. EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  tags = {
    Name = "EC2-${var.environment}"
  }
}

# 2. S3 Bucket for Static Website
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 3. IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.static_website_bucket.arn,
          "${aws_s3_bucket.static_website_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 4. Lambda Function
resource "aws_lambda_function" "s3_event_logger" {
  filename         = "C:/Users/91860/Desktop/Code/Terraform/experiment/day-8/lambda_function.zip"  # Zipped file you will create
  function_name    = "s3_event_logger"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  
  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

# 5. Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_event_logger.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.static_website_bucket.arn
}

# 6. Setup S3 Notification to trigger Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.static_website_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_event_logger.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
