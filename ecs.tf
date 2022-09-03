data "aws_ami" "amazon2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-*-hvm-*-arm64-gp2"]
  }
  filter {
    name = "architecture"
    values = ["arm64"]
  }
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-ec2"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.asg.auto_scaling_group_arn
    #   "arn:aws:autoscaling:eu-west-1:012345678901:autoScalingGroup:08419a61:autoScalingGroupName/ecs-ec2-one-20220603194933774300000011"
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
    # two = {
    #   auto_scaling_group_arn         = module.autoscaling.auto_scaling_group_arn
    # #   "arn:aws:autoscaling:eu-west-1:012345678901:autoScalingGroup:08419a61:autoScalingGroupName/ecs-ec2-two-20220603194933774300000022"
    #   managed_termination_protection = "ENABLED"

    #   managed_scaling = {
    #     maximum_scaling_step_size = 15
    #     minimum_scaling_step_size = 5
    #     status                    = "ENABLED"
    #     target_capacity           = 90
    #   }

    #   default_capacity_provider_strategy = {
    #     weight = 40
    #   }
    # }
  }

  tags = {
    Environment = var.env
    Project     = "ECS-${var.service_name}"
    Name        = var.service_name

  }
}
# module "hello_world" {
#   source = "./service-hello-world"

#   cluster_id = module.ecs.cluster_id
# }
# data "aws_ssm_parameter" "ecs_optimized_ami" {
#   name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
# }

# module "autoscaling" {
#   source  = "terraform-aws-modules/autoscaling/aws"
#   version = "~> 6.5"

#   for_each = {
#     one = {
#       instance_type = "t3.micro"
#     }
#     two = {
#       instance_type = "t3.small"
#     }
#   }

#   name = "ecs-${var.service_name}-${each.key}"

#   image_id      = data.aws_ami.amazon2
#   #  jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
#   instance_type = each.value.instance_type

#   security_groups                 = ["${aws_security_group.ecs_sg.id}"]
#   user_data                       = base64encode(local.user_data)
#   ignore_desired_capacity_changes = true

#   create_iam_instance_profile = true
#   iam_role_name               = "${var.service_name}-ecs-role"
#   iam_role_description        = "ECS role for ${var.service_name} EC2"
#   iam_role_policies = {
#     AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#     AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#     AmazonS3FullAccess                  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   }

#   vpc_zone_identifier = module.vpc.private_subnets
#   health_check_type   = "EC2"
#   min_size            = 1
#   max_size            = 2
#   desired_capacity    = 1

#   # https://github.com/hashicorp/terraform-provider-aws/issues/12582
#   autoscaling_group_tags = {
#     AmazonECSManaged = true
#   }

#   # Required for  managed_termination_protection = "ENABLED"
#   protect_from_scale_in = true

#   tags = local.tags
# }

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.service_name}"
  retention_in_days = 7

  tags = local.tags
}