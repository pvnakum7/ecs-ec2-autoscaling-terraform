resource "aws_ecs_task_definition" "task_definition" {
  family                = "worker"
  network_mode          = "bridge"
#   container_definitions = data.template_file.task_definition_template.rendered
  container_definitions = jsonencode([
    {
      name      = "helloword"
      image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
      cpu       = 20
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ]
    }
    ,{
      name      = "second"
      image     = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
      cpu       = 20
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 0
        }
      ]
    }
  ])

}

resource "aws_ecs_service" "worker" {
  name            = "worker"
  depends_on = [aws_ecs_task_definition.task_definition
    
  ]
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1


  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    subnets         = module.vpc.public_subnets
    }

  load_balancer {
    # associate_alb = module.alb
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "helloword"
    container_port   = 80
  }



}

