
### https://medium.com/@sampark02/application-load-balancer-and-target-group-attachment-using-terraform-d212ce8a38a0
#### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
## cat lb_listener.tf # Listener rule for HTTP traffic on each of the ALBs
resource "aws_lb_listener" "http_listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listeners" {
  # count = length(var.service_list)   
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.default[count.index].arn
  # }
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Attention please add new target group."
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "static" {
  count = length(var.service_list)  
  listener_arn = aws_lb_listener.https_listeners.arn
  priority     = count.index+100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/${var.service_path[count.index]}/*"]
    }
  }

  condition {
    host_header {
      values = ["${var.service_domain[count.index]}"]
    }
  }
}


# resource "aws_lb_listener" "lb_listener_http" {
#   #  for_each             = var.service_list
#    count                = length(var.service_list)
#    weight               = "100"
#    load_balancer_arn    = aws_lb.alb.arn
#    port                 = "80"
#    path                 = "/admin"
#    protocol             = "HTTP"
#    default_action {
#     # target_group_arn = aws_lb_target_group.default[each.value].id
#     target_group_arn = aws_lb_target_group.sample_tg[count.index].id
#     type             = "forward"
#   }
# }
