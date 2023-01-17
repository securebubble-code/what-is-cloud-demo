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

