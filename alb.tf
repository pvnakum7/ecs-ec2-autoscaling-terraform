# ##################################################################
# # Application Load Balancer
# ##################################################################


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "alb-${var.service_name}-${var.env}"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = module.vpc.public_subnets
  enable_deletion_protection = true

  # access_logs = {
  #   bucket = "my-alb-logs"
  # }

  target_groups = [
    {
      name_prefix         = "tg-"
      Name                = "${var.service_name}-${var.env}"
      healthy_threshold   = "3"
      interval            = "10"
      port                = 80
      backend_protocol    = "HTTP"
      backend_port        = 80
      target_type         = "instance"
      path                = "/"
      # status_code = 403
      status_code         = 200
      unhealthy_threshold = "3"
     }
     
    #,
    # {
    #   name_prefix      = "tg-"
    #   Name = "${var.service_name}-${var.env}"
    #   backend_protocol = "HTTP"
    #   backend_port     = 80
    #   target_type      = "instance"
    # }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      
    }
    }
]

  tags = {
    Environment = var.env
    Name = var.service_name
  }
}