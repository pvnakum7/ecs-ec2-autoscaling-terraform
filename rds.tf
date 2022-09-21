## https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.3"
  identifier = "db-${var.service_name}-${var.env}"

  engine               = "mysql"
  engine_version       = "8.0.27"
  major_engine_version = "8.0"      # DB option group
  instance_class       = var.db_instancetype

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  port     = var.db_port
  create_random_password = false
  password = var.db_password
  
  # Database Deletion Protection
  deletion_protection = true
  multi_az               = false
  # DB parameter group
  family               = "mysql8.0" # DB parameter group
  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets       
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 0
  skip_final_snapshot     = true

  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.tags
  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sg_${var.service_name}_${var.env}_RDS"
  description = "Complete MySQL example security group"
  vpc_id      = module.vpc.vpc_id
  

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}


# output "pass" {

#   value = var.db_password
# }