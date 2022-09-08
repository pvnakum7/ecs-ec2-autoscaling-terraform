module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.1"

  cluster_name = "ecs-${local.name}-${var.env}" 
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        # You can set a simple string and ECS will create the CloudWatch log group for you
        # or you can create the resource yourself as shown here to better manage retetion, tagging, etc.
        # Embedding it into the module is not trivial and therefore it is externalized
        cloud_watch_log_group_name = "ECS_${local.name}_Logs"
      }
    }
  }

  # ########Capacity provider - autoscaling groups
  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.autoscaling["one"].autoscaling_group_arn
      # auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        
        status                    = "ENABLED"
        target_capacity           = 90
      }

      default_capacity_provider_strategy = {
        base   = 3
        weight = 1
      }
    }
    # two = {
    #   auto_scaling_group_arn         = module.autoscaling["two"].autoscaling_group_arn
    #   managed_termination_protection = "DISABLED"

    #   managed_scaling = {
    #     maximum_scaling_step_size = 0
    #     minimum_scaling_step_size = 0
    #     status                    = "ENABLED"
    #     target_capacity           = 90
    #   }

    #   default_capacity_provider_strategy = {
    #     base   = 0
    #     weight = 1
    #   }
    # }
   }

  tags = local.tags
}

