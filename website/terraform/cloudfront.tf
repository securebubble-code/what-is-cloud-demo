resource "aws_cloudfront_distribution" "main_distribution" {
  origin {
    domain_name = aws_s3_bucket.main-website.bucket_regional_domain_name
    origin_id   = "s3-${local.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main-website-oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.bucket_name} website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.main-website-logging.bucket_domain_name
    prefix          = "cdn"
  }

  aliases = [ local.bucket_name, "www.${local.bucket_name}" ]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${local.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  depends_on = [
    aws_acm_certificate.site-alias
  ]

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU","KP","CN"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site-alias.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "main-website-oac" {
  name                              = "${local.bucket_name}-oac"
  description                       = "Access Control policy for the ${local.bucket_name} website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_identity" "main-website-oai" {
  comment = "${local.bucket_name}-oai"
}