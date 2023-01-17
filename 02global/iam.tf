# Roles and Groups for default EC2 instance profiles role
resource "aws_iam_role" "ir-role-systems-manager" {
  name               = "${var.prefix}-role-systems-manager"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com",
                    "ssm.amazonaws.com"
                ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "irp-policy-systems-manager" {
  name   = "${var.prefix}-policy-systems-manager"
  role   = aws_iam_role.ir-role-systems-manager.id
  policy = <<EOF
{
"Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.prefix}-automation",
                "arn:aws:s3:::${var.prefix}-automation/*"
            ]
        }
    ]
}
EOF
}

# Data source to pull in AWS SSM Managed policy
data "aws_iam_policy" "ssm-managed-policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach SSM Managed policy to EC2 role
resource "aws_iam_role_policy_attachment" "ssm-managed-policy-attach" {
  role       = aws_iam_role.ir-role-systems-manager.name
  policy_arn = data.aws_iam_policy.ssm-managed-policy.arn
}


resource "aws_iam_group" "grp-s3-automation-access" {
  name = "${var.prefix}-s3-automation-access"
  path = "/"
}

resource "aws_iam_policy" "pol-s3-automation-access" {
  name        = "${var.prefix}-s3-automation-access"
  path        = "/"
  description = "terraform generated policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.prefix}-automation"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "pol-att-grp-s3-automation-access" {
  group      = aws_iam_group.grp-s3-automation-access.name
  policy_arn = aws_iam_policy.pol-s3-automation-access.arn
}

resource "aws_iam_user" "main-website-table" {
  name = "main-website-table"
  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "main-website-table-user" {
  user = aws_iam_user.main-website-table.name
}

resource "aws_iam_user_policy" "main-website-table-policy" {
  name = "main-website-table-policy"
  user = aws_iam_user.main-website-table.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:List*",
        "dynamodb:GetItem",
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.main-website-table.arn}"
    }
  ]
}
EOF
}