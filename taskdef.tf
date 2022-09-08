# data "aws_iam_policy_document" "ecs_agent" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ecs_agent" {
#   name               = "ecs-agent"
#   assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
# }


# resource "aws_iam_role_policy_attachment" "ecs_agent" {
#   role       = "aws_iam_role.ecs_agent.name"
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

# resource "aws_iam_instance_profile" "ecs_agent" {
#   name = "ecs-agent"
#   role = aws_iam_role.ecs_agent.name
# }


resource "aws_ecs_task_definition" "task_definition" {
  family                = "frontend"
  # requires_compatibilities = ["EC2"]
#   execution_role_arn    = aws_iam_instance_profile.ecs_agent.arn
#   ipc_mode              = var.ipc_mode
   network_mode          = "bridge"
#   pid_mode              = var.pid_mode
#   task_role_arn         = var.task_role_arn  
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
      cpu       = 50
      memory    = 768
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
    # ,{
    #   name      = "second"
    #   image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
    #   cpu       = 10
    #   memory    = 256
    #   essential = true
    #   portMappings = [
    #     {
    #       containerPort = 443
    #       hostPort      = 443
    #     }
    #   ]
    # }
  ])
 
}



## Ref: https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/
resource "aws_ecs_service" "worker" {
  name            = "nginx"
  cluster         = module.ecs.cluster_id
  
  launch_type            = "EC2"  
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  depends_on    = [aws_security_group.ecs_sg,module.alb,module.alb.https_listeners,module.alb.http_tcp_listeners]

  load_balancer {

    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "nginx"
    container_port   = 8080
  }

  # network_configuration {
  #   security_groups = [aws_security_group.ecs_sg.id]
  #   subnets         = module.vpc.public_subnets
  #   }
  # network_configuration {
  #   security_groups       = ["sg-01849003c4f9203ca"] #CHANGE THIS
  #   subnets               = ["${var.subnet1}", "${var.subnet2}"]  ## Enter the private subnet id
  #   assign_public_ip      = "false"
  # }
  
  
  
}

# output "ecr_repository_worker_endpoint" {
#     value = aws_ecr_repository.worker.repository_url
# }