provider "aws" {
  region = "us-east-1" # Specify the AWS region
}

resource "aws_s3_bucket" "app_data_bucket" {
  bucket        = "myapp-dev-us-west-2-data-bucket" # Descriptive and unique bucket name
  acl           = "private"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Enable server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Set up lifecycle rules
  lifecycle_rule {
    id      = "lifecycle-expire-old-objects"
    enabled = true

    expiration {
      days = 30 # Automatically delete objects after 30 days
    }

    noncurrent_version_expiration {
      days = 90 # Automatically delete noncurrent object versions after 90 days
    }
  }

  # Tags for the bucket
  tags = {
    Name        = "myapp-dev-data-bucket"
    Environment = "Development"
    Application = "MyApp"
    Owner       = "DevTeam"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data_bucket.bucket
}
