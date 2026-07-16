provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# This S3 bucket VIOLATES our policy (no encryption, public-read ACL)
resource "aws_s3_bucket" "policy_violation_bucket" {
  bucket = "circleci-lab-violation-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_acl" "policy_violation_bucket_acl" {
  bucket = aws_s3_bucket.policy_violation_bucket.id
  acl    = "public-read"  # This violates our policy
}

# Random suffix to ensure unique bucket names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

output "bucket_name" {
  value = aws_s3_bucket.policy_violation_bucket.bucket
}
