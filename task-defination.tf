
###### ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition

resource "aws_ecs_task_definition" "task_definition" {
  # count                 =  length(var.ecs_tasks)
  count                 =  length(var.my_ecs_tasks.container_name)
  family                = var.my_ecs_tasks.family[count.index]
  volume {
    name      = "data"
    host_path = var.my_ecs_tasks.container_mount_path
  }
  # container_definitions = jsonencode([local.my_ecs_tasks[count.index]])
  container_definitions = jsonencode([{
    name                = var.my_ecs_tasks.container_name[count.index]
    image               = var.my_ecs_tasks.container_image[count.index]
    # cpu                 = var.container_cpu[count.index]
    memory              = var.my_ecs_tasks.container_memory
    essential           = true
    portMappings = [{
      containerPort     = var.my_ecs_tasks.container_port
      hostPort = 0
    }]
    logConfiguration = {
      logDriver   = "awslogs"
      options     = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
        awslogs-region        = var.region 
        awslogs-stream-prefix = "${var.my_ecs_tasks.container_name[count.index]}-${var.env}"
      }
    }
    mountPoints     = [{
      sourceVolume  = "data",
      containerPath = var.my_ecs_tasks.container_mount_path,
    }]
  }])
  
  # requires_compatibilities = var.ecs_task.requires_compatibilities
  # network_mode             = var.ecs_task.network_mode
  network_mode          = "bridge"
  # execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

output "task_definition_count" {

  value = length(var.my_ecs_tasks)
}










