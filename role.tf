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