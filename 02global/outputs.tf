# Output variables
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3-automation.arn
}

output "dynamodb_user_access_key" {
  value = aws_iam_access_key.main-website-table-user.id
}

output "dynamodb_user_secret" {
  value = aws_iam_access_key.main-website-table-user.secret
  sensitive = true
}