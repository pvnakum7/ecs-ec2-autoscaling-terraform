## Ref: https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/
resource "aws_ecs_service" "worker" {
  count = length(var.my_ecs_tasks.service_name)
  name            = var.my_ecs_tasks.service_name[count.index]
  cluster         = module.ecs.cluster_id
 
  # launch_type     = "EC2"
  # capacity_provider_strategy { # forces replacement
  #   base              = 1
  #   capacity_provider = "one"
  #   weight            = 1
  # }
  task_definition = aws_ecs_task_definition.task_definition[count.index].arn  
  desired_count   = var.my_ecs_tasks.service_desired_count[count.index]
  depends_on    = [aws_security_group.ecs_sg,aws_lb.alb,aws_lb_listener.http_listeners,aws_lb_listener.https_listeners]
  
  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }
    lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }
  # lifecycle {
  #   ignore_changes = [desired_count]
  # }

  load_balancer {
    # target_group_arn = module.alb.target_group_arns[count.index].arn
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
    container_name   = var.my_ecs_tasks.container_name[count.index]
    container_port   = var.my_ecs_tasks.container_port
  }
  
}

#### Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
resource "aws_appautoscaling_target" "ecs_target" {
  count = length(var.my_ecs_tasks.service_name)
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.worker[count.index].name}"
  # resource_id = "service/${module.ecs.ecs_}/serviceName"
  scalable_dimension = var.my_ecs_tasks.scalable_dimension[count.index]
  service_namespace  = var.my_ecs_tasks.service_namespace[count.index]
}

resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  count = length(var.my_ecs_tasks.service_name)
  name               = "app-${var.my_ecs_tasks.service_name[count.index]}-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace
  

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70 # 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  count = length(var.my_ecs_tasks.service_name)
  name               = "app-${var.my_ecs_tasks.service_name[count.index]}-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 82 # 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}


## extra manage 

#### Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy

resource "aws_appautoscaling_policy" "ecs_policy" {
  count = length(var.my_ecs_tasks.service_name)
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
