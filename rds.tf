

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.3"
  identifier = "db-${var.service_name}-${var.env}"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  db_name  = var.db_name
  username = var.username
  port     = var.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.security_group.id]
#   ,"${aws_security_group.rds.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "60"
  monitoring_role_name = "RDS-${var.service_name}-Monitoring-Role"
  create_monitoring_role = true

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }
  tags = local.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
#   ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = true
  multi_az               = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}



module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sg-${var.service_name}-${var.env}-RDS"
  description = "Complete MySQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access VPC"
      cidr_blocks = module.vpc.vpc_cidr
    },
  ]

  tags = local.tags
}