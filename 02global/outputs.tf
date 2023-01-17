# Output variables
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3-automation.arn
}