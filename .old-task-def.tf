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





# resource "aws_ecs_task_definition" "task_definition" {
#   family                = "frontend"
#   # requires_compatibilities = ["EC2"]
#   network_mode          = "bridge"
#   # container_definitions = file("task-definitions/task-service.json")
#   # container_definitions = "${file("task-definitions/service.json")}"

#   container_definitions = jsonencode([
#     {
#       name      = "emplicheck-beta-user-frontend"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 50
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "admin"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 100
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "landing"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 100
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "api"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 100
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "five"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 100
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#   ])

#   volume {
#     name = "data"
#     efs_volume_configuration {
#       file_system_id          = var.efs_sys_id
#       root_directory          = var.mount_location
#       # transit_encryption      = "ENABLED"
#       # transit_encryption_port = 2999
#       # authorization_config {
#       #   access_point_id = var.access_point_id
#       #   iam             = "ENABLED"
#       # }
#     }
#   }
 
# }

# locals my_ecs_tasks {
#   my_ecs_tasks = [
#     {
#       name      = "api"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/api:latest"
#       cpu       = 256
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "admin"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 256
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "landing"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#       cpu       = 256
#       memory    = 128
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
#     ,{
#       name      = "emplicheck-beta-user-frontend"
#       image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/emplicheck-beta-user-frontend:latest"
#       cpu       = 256
#       memory    = 256
#       essential = true
#       mountPoints         = [{
#         sourceVolume: "data",
#         containerPath: "/mnt/efs",
#         readOnly: false
#       }]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 0
#         }
#       ]
#       logConfiguration = {
#         logDriver   = "awslogs"
#         options     = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
#           awslogs-region        = var.region 
#           awslogs-stream-prefix = "${var.service_name}-${var.env}"
#         }
#      }
#     }
# ]
# }


###### ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition

resource "aws_ecs_task_definition" "task_definition" {
  # count                 =  length(var.ecs_tasks)
  count                 =  length(var.my_ecs_tasks)
  family                = var.service_list[count.index]
  volume {
    name      = "data"
    host_path = var.container_mount_path[count.index]
  }
  # container_definitions = jsonencode([local.my_ecs_tasks[count.index]])
  container_definitions = jsonencode([{
    name                = var.container_name[count.index]
    image               = var.container_images[count.index]
    # cpu                 = var.container_cpu[count.index]
    memory              = var.container_memory[count.index]
    essential           = true
    portMappings = [{
      containerPort     = var.container_port[count.index]
      hostPort = 0
    }]
    logConfiguration = {
      logDriver   = "awslogs"
      options     = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
        awslogs-region        = var.region 
        awslogs-stream-prefix = "${var.service_list[count.index]}-${var.env}"
      }
    }
    mountPoints         = [{
      sourceVolume  = "data",
      containerPath = var.container_mount_path[count.index],
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










