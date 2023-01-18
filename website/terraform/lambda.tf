locals {
  lambda_prefix = "bc-demo-invalidate-index"
  lambda_name   = "${var.prefix}-${var.environment}-${local.lambda_prefix}"
}
resource "aws_cloudwatch_log_group" "bc-demo-invalidate-index" {
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "bc-demo-invalidate-index" {
  filename      = "code/${local.lambda_prefix}.zip"
  description   = "Triggers invalidation of index.html in CloudFront"
  function_name = "${local.lambda_name}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  environment {
    variables = {
      dist_id = aws_cloudfront_distribution.main_distribution.id
    }
  }
  source_code_hash = filebase64sha256("code/${local.lambda_prefix}.zip")

  depends_on = [
    aws_iam_role_policy_attachment.iam_for_lambda,
    aws_cloudwatch_log_group.bc-demo-invalidate-index,
    data.archive_file.bc-demo-invalidate-index
  ]
  timeout = 900
  tags = merge(var.tags, {
    Name        = "${local.lambda_prefix}",
    Environment = var.environment
    Managed     = "terraform"
  })
}

#Create Lambda function zip files
data "archive_file" "bc-demo-invalidate-index" {
  type        = "zip"
  source_dir  = "code/${local.lambda_prefix}"
  output_path = "code/${local.lambda_prefix}.zip"
}
