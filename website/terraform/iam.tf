resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.prefix}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_access_policy" {
  name        = "${var.prefix}-backend-policy"
  path        = "/"
  description = "IAM policy for lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "cloudfront:CreateInvalidation",
            "Resource": "${aws_cloudfront_distribution.main_distribution.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_access_policy.arn
}


## Optional resources to deploy IAM policy, user and group with access to make website changes
# resource "aws_iam_policy" "pol-main-website" {
#   name   = "${local.bucket_name}-update"
#   policy = <<EOF
# {
# "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:ListBucket",
#                 "s3:PutObject",
#                 "s3:PutObjectAcl",
#                 "s3:GetObject"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::${local.bucket_name}",
#                 "arn:aws:s3:::${local.bucket_name}/*"
#             ]
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_user" "usr-main-website" {
#   name = "${local.bucket_name}-update"
# }

# resource "aws_iam_group" "grp-main-website" {
#   name = "${local.bucket_name}-update"
#   path = "/"
# }

# resource "aws_iam_group_policy_attachment" "pol-att-grp-main-website" {
#   group      = aws_iam_group.grp-main-website.name
#   policy_arn = aws_iam_policy.pol-main-website.arn
# }

# resource "aws_iam_user_group_membership" "usr-grp-main-website-member" {
#   user = aws_iam_user.usr-main-website.name

#   groups = [
#     aws_iam_group.grp-main-website.name,
#   ]
# }

