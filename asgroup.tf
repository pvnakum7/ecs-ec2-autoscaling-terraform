# Gert From Main TF
data aws_ami "linux2ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = false ? ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"] : ["amzn-ami-*-amazon-ecs-optimized"]
  }
}


## ref: https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest/examples/complete
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  for_each = {
    one = {
      instance_type = var.ec2instance_type
    }
  #   two = {
  #     instance_type = var.ec2instance_type 
  # }
  }

  name = "asg-${local.name}-${each.key}-${var.env}"
  # name = "asg-${local.name}-${var.env}"

  target_group_arns = module.alb.target_group_arns
  # vpc_id = module.alb.vpc_id
  # image_id      = data.aws_ami.linux2ami.id
  image_id      = "ami-087de15a22879b9ef"
  # jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  # instance_type = each.value.instance_type
  instance_type = var.ec2instance_type
  key_name = var.key_pair
  initial_lifecycle_hooks = [
    {
      name                 = "EC2StartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "EC2TerminationLifeCycleHook"
      default_result       = "ABANDON"
      heartbeat_timeout    = 80
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 120
      checkpoint_percentages = [35,70, 100]
      instance_warmup        = 100
      min_healthy_percentage = 100
    }
    triggers = ["tag"]
  }
 
  # Launch template
  launch_template_name        = "complete-${local.name}"
  launch_template_description = "Complete launch template example"
  update_default_version      = true
  # user_data = base64encode("${file("install_apache.sh")}")   # base64encode(local.user_data)
  user_data = base64encode("#!/bin/bash  \n echo ECS_CLUSTER=${module.ecs.cluster_name} >> /etc/ecs/ecs.config") 
  # user_data = base64encode(local.user_data)>> /etc/ecs/ecs.config"
  ebs_optimized     = true
  enable_monitoring = true
  

  depends_on                    = [ aws_security_group.ecs_sg,aws_security_group.alb_sg]
  security_groups                 = ["${aws_security_group.ecs_sg.id}", "${aws_security_group.alb_sg.id}"]   # [module.autoscaling_sg.security_group_id]
  ignore_desired_capacity_changes = false

  create_iam_instance_profile = true
  iam_role_name               = "${local.name}-${var.env}-iamrole"
  iam_role_description        = "ECS role for ${local.name}-${var.env}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonS3FullAccess                  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }
    # AmazonElasticFileSystemServiceRolePolicy = "arn:aws:iam::aws:policy/aws-service-role/AmazonElasticFileSystemServiceRolePolicy"

  # vpc_zone_identifier = module.vpc.private_subnets
  vpc_zone_identifier = module.vpc.public_subnets
  termination_policies = ["OldestInstance"]
  default_cooldown = 120
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = false

  tags = local.tags
}

# module "autoscaling_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 4.0"

#   name        = local.name
#   description = "Autoscaling group security group"
#   vpc_id      = module.vpc.vpc_id



#   # ingress_cidr_blocks = ["0.0.0.0/0"]
#   # # ingress_rules       = ["https-443-tcp","http-80-tcp",]
#   ingress_rules       = ["all-all"]

#   egress_rules = ["all-all"]

#   tags = local.tags
# }