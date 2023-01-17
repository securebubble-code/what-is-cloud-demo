# Output variables

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.main-website-website-configuration.website_domain
}

output "route53_domain" {
  value = aws_route53_record.site-alias.fqdn
}

output "cdn_domain" {
  value = aws_cloudfront_distribution.main_distribution.domain_name
}