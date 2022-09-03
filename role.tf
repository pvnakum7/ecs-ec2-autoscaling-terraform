module "iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"

  trusted_role_arns = [
    "arn:aws:iam::918135752127:root",
    "arn:aws:iam::918135752127:user/paras-developer",
  ]

  create_role = true

  role_name         = "custom"
  role_requires_mfa = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
    "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess"
  ]
}


data "aws_iam_policy_document" "resource_full_access" {
#   count = local.enabled ? 1 : 0

  statement {
    sid       = "FullAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
  }
}

data "aws_iam_policy_document" "base" {
  # count = local.enabled ? 1 : 0

  statement {
    sid    = "BaseAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]

    resources = ["*"]
  }
}

# module "role" {
#   source = "cloudposse/terraform-aws-iam-role"

#   principals   = var.principals
#   use_fullname = var.use_fullname

#   policy_documents = [
#     join("", data.aws_iam_policy_document.resource_full_access.*.json),
#     join("", data.aws_iam_policy_document.base.*.json),
#   ]

#   policy_document_count = 2
#   policy_description    = "ECS IAM policy"
#   role_description      = " IAM role"

#   context = module.this.context
# }

