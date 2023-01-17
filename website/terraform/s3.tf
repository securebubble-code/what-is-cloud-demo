data "aws_iam_role" "terraform_role" {
  name = "github-terrraform-build-role"
}
resource "aws_s3_bucket" "main-website" {
  bucket        = local.bucket_name
  force_destroy = true
  tags = {
    Name        = local.bucket_name
    Description = "${local.bucket_name} website data"
    Managed     = "terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main-website-encryption" {
  bucket = aws_s3_bucket.main-website.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main-website-storage-block" {
  bucket                  = aws_s3_bucket.main-website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "main-website-website-configuration" {
  bucket = aws_s3_bucket.main-website.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_logging" "main-website-access-logging" {
  bucket = aws_s3_bucket.main-website.id

  target_bucket = aws_s3_bucket.main-website-logging.id
  target_prefix = "root/"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.main-website.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [ 
    {
      "Sid": "Allow-Bucket-Access-to-CloudFront",
      "Effect": "Allow",
      "Principal": {
          "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": [
        "${aws_s3_bucket.main-website.arn}",
        "${aws_s3_bucket.main-website.arn}/*"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "${aws_cloudfront_distribution.main_distribution.arn}"
        }
      }
    },
    {
    "Sid": "Deny-Bucket-Access-except-Users",
      "Effect": "Deny",
      "NotPrincipal": {
          "AWS": [
            "${data.aws_iam_role.terraform_role.arn}",
            "${aws_cloudfront_origin_access_identity.main-website-oai.iam_arn}"
          ]
      },
      "Action": "s3:GetObject",
      "Resource": [
        "${aws_s3_bucket.main-website.arn}",
        "${aws_s3_bucket.main-website.arn}/*"
      ]
    },
		{
			"Sid": "Deny-Bucket-Access-except-CloudFront",
			"Effect": "Deny",
			"NotPrincipal": {
				"Service" :"cloudfront.amazonaws.com"
			},
			"Action": "s3:GetObject",
			"Resource": [
				"${aws_s3_bucket.main-website.arn}",
        "${aws_s3_bucket.main-website.arn}/*"
			]
		}
  ]
}
EOF
}

resource "aws_s3_bucket" "main-website-logging" {
  bucket        = "${local.bucket_name}-logging"
  force_destroy = true
  tags = {
    Name        = "${local.bucket_name}-logging"
    Description = "${local.bucket_name} website access logs"
    Managed     = "terraform"
  }
}

resource "aws_s3_bucket_acl" "main-website-logging-acl" {
  bucket = aws_s3_bucket.main-website-logging.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main-website-logging-encryption" {
  bucket = aws_s3_bucket.main-website-logging.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main-website-logging-storage-block" {
  bucket                  = aws_s3_bucket.main-website-logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "main-website-logging-lifecycle-config" {
  bucket = aws_s3_bucket.main-website-logging.id

  rule {
    id = "auto-remove"

    filter {}
    expiration {
      days = 730
    }
    status = "Enabled"
  }
}
