resource "aws_launch_configuration" "ecs_launch_config" {
    image_id      = "ami-087de15a22879b9ef"
    iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data = base64encode("#!/bin/bash  \n echo ECS_CLUSTER=${module.ecs.cluster_name} >> /etc/ecs/ecs.config") 
    instance_type        = "t2.micro"
    key_name = var.key_pair
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "asg"
    vpc_zone_identifier = module.vpc.public_subnets
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "EC2"
}