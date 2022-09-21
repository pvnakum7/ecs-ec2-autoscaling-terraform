# resource "aws_ecs_task_definition" "ecs_tasks" {
#   for_each = var.create_tasks == true ? var.ecs_tasks : {}
#   family   = each.value["family"]
#   container_definitions = templatefile(each.value["container_definition"], "${merge("${var.extra_template_variables}",
#     {
#       container_name        = each.value["family"],
#       docker_image          = "${var.docker_image}:${var.docker_tag}",
#       aws_logs_group        = "/aws/ec2/${aws_ecs_cluster.cluster.name}/${each.value["family"]}/${var.env}",
#       aws_log_stream_prefix = each.value["family"],
#       aws_region            = var.region,
#       container_port        = each.value["container_port"]
#   })}")

#   # task_role_arn            = aws_iam_role.ecs_task_role.arn
#   network_mode             = var.task_definition_network_mode
#   cpu                      = each.value["cpu"]
#   memory                   = each.value["memory"]
#   requires_compatibilities = [var.ecs_launch_type == "EC2" ? var.ecs_launch_type : null]
#   execution_role_arn       = aws_iam_role.ecs_execution_role.arn

#   tags = merge({
#     "Name"        = "${each.value["family"]}-${var.environment}"
#     "Description" = "Task definition for ${each.value["family"]}"
#     }, var.tags
#   )
# }

# resource "aws_ecs_task_definition" "ecs_task" {
#   for_each = var.ecs_tasks
#   family                = var.ecs_task.family
#   container_definitions = jsonencode([{
#     name                = var.ecs_task.name
#     image               = var.ecs_task.container_image
#     cpu                 = var.ecs_task.cpu
#     memory              = var.ecs_task.memory
#     essential           = true
#     portMappings = [{
#       containerPort     = var.ecs_task.container_port
#       hostPort = var.ecs_task.host_port
#     }]
#   }])
#   requires_compatibilities = var.ecs_task.requires_compatibilities
#   network_mode             = var.ecs_task.network_mode
#   execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
# }


resource "aws_ecs_task_definition" "task_definition" {
  count                 =  length(var.ecs_tasks)
  family                = var.service_list[count.index]
  container_definitions = jsonencode([{
    name                = var.container_name[count.index]
    image               = var.container_images[count.index]
    cpu                 = 50
    memory              = 512
    essential           = true
    portMappings = [{
      containerPort     = var.container_port[count.index]
      hostPort = 0
    }]
  }])
  # requires_compatibilities = var.ecs_task.requires_compatibilities
  # network_mode             = var.ecs_task.network_mode
  network_mode          = "bridge"
  # execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

output "task_definition_count" {

  value = length(var.ecs_tasks)
}



# resource "aws_ecs_task_definition" "task_definition" {
#   family                = "frontend"
#   # requires_compatibilities = ["EC2"]
#   network_mode          = "bridge"
#   # container_definitions = file("task-definitions/task-service.json")
#   container_definitions = "${file("task-definitions/service.json")}"

#   # container_definitions = jsonencode([
#   #   {
#   #     name      = "nginx"
#   #     image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#   #     cpu       = 50
#   #     memory    = 128
#   #     essential = true
#   #     portMappings = [
#   #       {
#   #         containerPort = 80
#   #         hostPort      = 0
#   #       }
#   #     ]
#   #   }
#   #   ,{
#   #     name      = "second"
#   #     image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#   #     cpu       = 100
#   #     memory    = 128
#   #     essential = true
#   #     portMappings = [
#   #       {
#   #         containerPort = 80
#   #         hostPort      = 0
#   #       }
#   #     ]
#   #   }
#   #   ,{
#   #     name      = "third"
#   #     image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#   #     cpu       = 100
#   #     memory    = 128
#   #     essential = true
#   #     portMappings = [
#   #       {
#   #         containerPort = 80
#   #         hostPort      = 0
#   #       }
#   #     ]
#   #   }
#   #   ,{
#   #     name      = "forth"
#   #     image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#   #     cpu       = 100
#   #     memory    = 128
#   #     essential = true
#   #     portMappings = [
#   #       {
#   #         containerPort = 80
#   #         hostPort      = 0
#   #       }
#   #     ]
#   #   }
#   #   ,{
#   #     name      = "five"
#   #     image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#   #     cpu       = 100
#   #     memory    = 128
#   #     essential = true
#   #     portMappings = [
#   #       {
#   #         containerPort = 80
#   #         hostPort      = 0
#   #       }
#   #     ]
#   #   }
#   # ])
 
# }



## extra manage 

#### Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
# resource "aws_appautoscaling_target" "ecs_target" {
#   max_capacity       = 4
#   min_capacity       = 1
#   resource_id        = aws_ecs_service.worker.id
#   scalable_dimension = 1
#   # aws_ecs_service.worker.desired_count
#   service_namespace  = aws_ecs_service.worker.name
# }

# resource "aws_appautoscaling_policy" "ecs_policy" {
#   name               = "scale-down"
#   policy_type        = "StepScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }


