
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
  #   target_group_arn = aws_lb_target_group.target_group[count.index].arn
  # }
  default_action {
    order = 1
    type  = "redirect"
    redirect {
      host        = var.site_domain_name
      path        = "/frontend"
      port        = "443"
      protocol    = "HTTPS"
      # query       = "#{query}"
      status_code = "HTTP_301"
      

    }
    # type = "fixed-response"
    # fixed_response {
    #   content_type = "text/html"
    #   message_body = "<h1> <center>Temporary server on maitances</center></h1>"
    #   status_code  = "200"
    # }
  }
}

resource "aws_lb_listener_rule" "static" {
  count = length(var.listener_vars.service_name)  
  listener_arn = aws_lb_listener.https_listeners.arn
  priority     = var.listener_vars.priority[count.index]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/${var.listener_vars.service_path[count.index]}","/${var.listener_vars.service_path[count.index]}/*",]
    }
  }

  condition {
    host_header {
      values = ["${var.listener_vars.service_domain[count.index]}"]
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





