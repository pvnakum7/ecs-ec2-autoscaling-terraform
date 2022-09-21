##  ### Ref:  https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest


module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.1"

  cluster_name = "ecs-${local.name}-${var.env}" 
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "ECS_${local.name}_Logs"
      }
    }
  }
  #  autoscaling_capacity_providers = [aws_ecs_cluster_capacity_providers.first_provider.name]
  # ########Capacity provider - autoscaling groups
  # default_capacity_provider_strategy {
	# capacity_provider = aws_ecs_capacity_provider.first_provider.name
	#   weight = 3
	#   base = 0
  # }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.autoscaling["one"].autoscaling_group_arn
      # auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn
      # managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 1   
        minimum_scaling_step_size = 1   
        
        status                    = "ENABLED"
        target_capacity           = 100    ## 90
      }

      default_capacity_provider_strategy = {
        # capacity_provider = "one"
        capacity_provider = aws_ecs_capacity_provider.first_provider.name
        base   = 3
        weight = 1
      }
    }
  #   # two = {
  #   #   auto_scaling_group_arn         = module.autoscaling["two"].autoscaling_group_arn
  #   #   managed_termination_protection = "DISABLED"

  #   #   managed_scaling = {
  #   #     maximum_scaling_step_size = 0
  #   #     minimum_scaling_step_size = 0
  #   #     status                    = "ENABLED"
  #   #     target_capacity           = 90
  #   #   }

  #   #   default_capacity_provider_strategy = {
  #   #     base   = 0
  #   #     weight = 1
  #   #   }
  #   # }
   }

  tags = local.tags
}



resource "aws_ecs_cluster_capacity_providers" "one" {
  cluster_name = module.ecs.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.first_provider.name]
  
  default_capacity_provider_strategy {
    base              = 3
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.first_provider.name
  }
}

resource "aws_ecs_capacity_provider" "first_provider" {
  name = "one"
  
  auto_scaling_group_provider {
    auto_scaling_group_arn = module.autoscaling["one"].autoscaling_group_arn
    # auto_scaling_group_arn = [module.autoscaling.arn]
    managed_termination_protection = "DISABLED"
    managed_scaling  {
        instance_warmup_period    = 80
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }
  
  }
}
