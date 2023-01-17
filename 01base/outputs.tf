# Outputs remote state bucket domain name, id and arn
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "s3-terraform-state-storage_domain_name" {
  value = aws_s3_bucket.s3-terraform-state-storage.bucket_domain_name
}
output "s3-terraform-state-storage_id" {
  value = aws_s3_bucket.s3-terraform-state-storage.id
}
output "s3-terraform-state-storage_arn" {
  value = aws_s3_bucket.s3-terraform-state-storage.arn
}