# Create Route 53 record
data "aws_route53_zone" "main_zone" {
  name = "${var.top_level_domain}."
}

resource "aws_route53_record" "site-alias" {
  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "${local.bucket_name}"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.main_distribution.domain_name
    zone_id = aws_cloudfront_distribution.main_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site-alias-www" {
  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "www.${local.bucket_name}"
  type    = "CNAME"
  ttl     = 300
  records = [
    "${local.bucket_name}"
  ]
}

# Create ACM certificate
resource "aws_acm_certificate" "site-alias" {
  provider = aws.us-east-1
  domain_name               = "${local.bucket_name}"
  subject_alternative_names = ["www.${local.bucket_name}"]
  validation_method = "DNS"
}

resource "aws_route53_record" "site-alias-cert" {
  for_each = {
    for dvo in aws_acm_certificate.site-alias.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main_zone.zone_id
}

resource "aws_acm_certificate_validation" "site-alias" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.site-alias.arn
  validation_record_fqdns = [for record in aws_route53_record.site-alias-cert : record.fqdn]
}
