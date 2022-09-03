resource "aws_security_group" "ecs_sg" {
    vpc_id      = module.vpc.vpc_id
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
    Name = "${var.env}-${var.service_name}-SG-EC2"
  }
}

resource "aws_security_group" "rds_sg" {
    vpc_id      = module.vpc.vpc_id

    ingress {
        protocol        = "tcp"
        from_port       = 3306
        to_port         = 3306
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.ecs_sg.id]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
      tags = {
    Name = "${var.env}-${var.service_name}-SG-RDS"
  }
}
## ALB security groups
resource "aws_security_group" "alb_sg" {
  name        = "sg_alb_${var.service_name}"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr}","${aws_security_group.ecs_sg.id}","${aws_security_group.rds_sg.id}"] 
   
  }
  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr}","${aws_security_group.ecs_sg.id}","${aws_security_group.rds_sg.id}"] 
   
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "allow_tls"
  }
}





# #### ALB

# resource "aws_lb" "alb" {
#   name               = "sg-alb-${var.service_name}-${var.env}"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = module.vpc.public_subnets
  
#   enable_deletion_protection = true

#   # access_logs {
#   #   bucket  = aws_s3_bucket.lb_logs.bucket
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }

#   tags = {
#     Environment = var.env
#     Name = "alb-${var.service_name}"
#   }
# }


# resource "aws_lb_target_group" "tg" {
#   name     = "tg-${var.service_name}-${var.env}-lb"
#   port     = 80
#   target_type = "alb"
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
# }

# resource "aws_lb_target_group_attachment" "targerattached" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = module.autoscaling.id
#   port             = 80
# }