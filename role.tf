# module "iam_assumable_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "~> 2.0"

#   trusted_role_arns = ["arn:aws:iam::918135752127:user/paras-developer",
#   ]

#   create_role = true

#   role_name         = "custom"
#   role_requires_mfa = true
#   custom_role_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
#     "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
    

#   ]
# }
# Define policy ARNs as list
variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
  default  = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", 
              "arn:aws:iam::aws:policy/AmazonS3FullAccess",
              "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
              "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
              
  ]
}

# Then parse through the list using count
# resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
#   role       = "iam_instance_profile"
#   count      = "${length(var.iam_policy_arn)}"
#   policy_arn = "${var.iam_policy_arn[count.index]}"
# }

# data "aws_iam_policy_document" "resource_full_access" {
# #   count = local.enabled ? 1 : 0

#   statement {
#     sid       = "FullAccess"
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "s3:PutObject",
#       "s3:PutObjectAcl",
#       "s3:GetObject",
#       "s3:DeleteObject",
#       "s3:ListBucket",
#       "s3:ListBucketMultipartUploads",
#       "s3:GetBucketLocation",
#       "s3:AbortMultipartUpload"
#     ]
#   }
# }

# data "aws_iam_policy_document" "base" {
#   # count = local.enabled ? 1 : 0

#   statement {
#     sid    = "BaseAccess"
#     effect = "Allow"

#     actions = [
#       "s3:ListBucket",
#       "s3:ListBucketVersions"
#     ]

#     resources = ["*"]
#   }
# }

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

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
  # "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "ecs-iam-instance-profile"
  role = aws_iam_role.ecs_agent.name
}