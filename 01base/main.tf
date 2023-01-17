# Creates an S3 bucket for storing the state file and protects from deletion
# Creates a DynamoDB for locking the state file and protects from deletion
locals {
  remote_state_bucket_name        = "${var.prefix}-${var.remote_state_bucket_name}"
  remote_state_dynamodb_lock_name = "${var.prefix}-${var.remote_state_dynamodb_lock_name}"
}

# Provider to pull account details
provider "aws" {
  region = var.aws_region
  alias  = "identity"
}

data "aws_caller_identity" "current" {
  provider = aws.identity
}

# Initial build and then config of remote state
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "~> 1.3.7"

  #;backend "s3" {
  #;  encrypt        = true
  #;  bucket         = "brighton-cloud-demos-terraform-state-storage"
  #;  dynamodb_table = "brighton-cloud-demos-terraform-state-lock"
  #;  key            = "brighton-cloud-demos/base.tfstate"
  #;  region         = "eu-west-1"
  #;}
}

# create an S3 bucket for storing the state file (versioning, encryption, and public access block enabled)
resource "aws_s3_bucket" "s3-terraform-state-storage" {
  bucket        = local.remote_state_bucket_name
  force_destroy = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-terraform-state-storage-encryption" {
  bucket = aws_s3_bucket.s3-terraform-state-storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3-terraform-state-storage-versioning" {
  bucket = aws_s3_bucket.s3-terraform-state-storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-terraform-state-storage-block" {
  bucket                  = aws_s3_bucket.s3-terraform-state-storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = local.remote_state_dynamodb_lock_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [name]
  }
}
