resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "ecs-log-${var.service_name}-${var.env}"
  retention_in_days = 7

  tags = {
    Environment = var.env
    Name        = "${var.service_name}-log"
    Type        = "ecs-container-log"
  }
}