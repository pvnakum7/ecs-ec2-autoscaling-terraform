# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html

# TODO : It is possible to attach additional containers on different
# ports using aws_lb_target_group_attachment
# https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html
# Should we support this?

resource "aws_lb_target_group" "default" {
   count              = length(var.service_list)
   name               = "tg-${var.service_list[count.index]}"
   target_type        = "instance"
   port               = 80
   protocol           = "HTTP"
   vpc_id             = module.vpc.vpc_id
   health_check {
      enabled             = "true"
      healthy_threshold   = var.healthy_threshold[count.index]
      interval            = var.interval[count.index]
      matcher             = var.matcher[count.index]
      path                = var.path[count.index]
      # port                = var.port[count.index]
      protocol            = var.protocol[count.index]
      timeout             = var.timeout[count.index]
      unhealthy_threshold = var.unhealthy_threshold[count.index]
  }
  #  health_check {
  #     healthy_threshold   = var.health_check["healthy_threshold"]
  #     interval            = var.health_check["interval"]
  #     unhealthy_threshold = var.health_check["unhealthy_threshold"]
  #     timeout             = var.health_check["timeout"]
  #     path                = var.health_check["path"]
  #     port                = var.health_check["port"]
  # }
}


output "tg_service_count" {
  value = length(var.service_list)
}


# resource "aws_lb_target_group" "default" {
#   # count = length(var.service_list) > 0 ? 1 : 0
#   count = length(var.service_list)

#   name  = "tg-${var.service_list[count.index]}"
#   port  = var.container_port[count.index]

#   # Valid vales for protocol are HTTP/HTTPS. We only support HTTP
#   # because we trust the path between the load balancer and the
#   # containers. If not then do NOT use a load balancer.
#   protocol = "HTTP"

#   vpc_id = module.vpc.vpc_id

#   # deregistration_delay = local.deregistration_delay

#   # dynamic "stickiness" {
#   #   for_each = [var.stickiness]
#   #   content {
#   #     cookie_duration = lookup(stickiness.value, "cookie_duration", null)
#   #     enabled         = lookup(stickiness.value, "enabled", null)
#   #     type            = stickiness.value.type
#   #   }
#   # }
#  health_check {
#       enabled             = "true"
#       healthy_threshold   = var.healthy_threshold[count.index]
#       interval            = var.interval[count.index]
#       matcher             = var.matcher[count.index]
#       path                = var.path[count.index]
#       port                = var.port[count.index]
#       protocol            = var.protocol[count.index]
#       timeout             = var.timeout[count.index]
#       unhealthy_threshold = var.unhealthy_threshold[count.index]
#   }

#   # dynamic "health_check" {
#   #   for_each = [var.health_check]
#   #   content {
#   #     enabled             = lookup(health_check.value[count.index], "enabled", null)
#   #     healthy_threshold   = lookup(health_check.value[count.index], "healthy_threshold", null)
#   #     interval            = lookup(health_check.value[count.index], "interval", null)
#   #     matcher             = lookup(health_check.value[count.index], "matcher", null)
#   #     path                = lookup(health_check.value[count.index], "path", null)
#   #     port                = lookup(health_check.value[count.index], "port", null)
#   #     protocol            = lookup(health_check.value[count.index], "protocol", null)
#   #     timeout             = lookup(health_check.value[count.index], "timeout", null)
#   #     unhealthy_threshold = lookup(health_check.value[count.index], "unhealthy_threshold", null)
#   #   }
#   # }
#   # target_type = local.network_mode == "awsvpc" ? "ip" : "instance"

#   tags = merge({ "Name" = var.service_name }, local.tags)
# }


