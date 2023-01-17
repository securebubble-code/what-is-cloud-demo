# S3 bucket for generic automation data
resource "aws_s3_bucket" "s3-automation" {
  bucket = "${var.prefix}-automation"
  force_destroy = true
  tags = {
    Name        = "${var.prefix}-automation"
    Description = "Stores resources for automation"
    Managed     = "terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-automation-encryption" {
  bucket = aws_s3_bucket.s3-automation.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-automation-storage-block" {
  bucket                  = aws_s3_bucket.s3-automation.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}