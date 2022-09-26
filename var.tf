#example : fill your information
variable "region" {
  default = "us-east-1"
}
variable "accountid"{
  type        = string
  default     = ""
}
variable "s3bucketname"{
  type        = string
  default     = "twolc-tech-dev"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet" {
  description = "Assigns IPv4 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet" {
  description = "Assigns IPv4 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# variable "kms_key_arn" {
#   type =  string
#   default = ""
#   description = "kmsemplicheck"
# }

variable "service_name" {
  default = "emplicheck"
}
variable "env" {
  default = "dev"
}
variable "ec2image_id"{
  type =  string
  default = ""
  description = " instance Custome ECS image ID"
}

variable "ec2instance_type"{
  type =  string
  default = "t3.small"
  description = " instance type"
}
variable "ec2instance_type2"{
  type =  string
  default = "t3.small"
  description = " instance type"
}

variable "key_pair"{
  type =  string
  default = "dev-emplicheck"
  description = " instance type"
}

#################################################Route53 ###############################################
variable "domain_name" {
  default = "emplicheck.com"
}

variable "site_domain_name" {
  default = "beta.emplicheck.com"
}
variable "zone_id" {
  # default = "Z08187652TPA8ZWLMHNDL"   ## 2lc.tech
  default = "Z0837020QGK65OGH76AN"
}

variable "cert_domain_list" {
  type    = list(string)
  default = ["*.emplicheck.com","*.beta.emplicheck.com","api.beta.emplicheck.com"]
  # []"*.${var.domain_name}"]
}
#################################################RDS ###############################################
variable "db_name" {
  default = "db2lc"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  type =  string
  default = ""
}
variable "db_port" {
  default = "3306"
}

variable "db_instancetype" {
  default = "db.t3.micro"
}
################################################################Container Service################################
variable "my_ecs_tasks" {
  description = "Map of variables to define an ECS task."
  type = object({
    container_image = list(string),
    container_mount_path = string,
    container_port  = number,
    cpu             = number,
    container_memory  = number,
    family            = list(string),
    container_name    = list(string),
    service_name = list(string),
    service_desired_count = list(number),
    scalable_dimension = list(any),
    service_namespace = list(any)
    # network_mode    = "bridge"
  })
  default = {
    container_image = ["918135752127.dkr.ecr.us-east-1.amazonaws.com/api:latest","918135752127.dkr.ecr.us-east-1.amazonaws.com/admin:latest", "918135752127.dkr.ecr.us-east-1.amazonaws.com/landing:latest","918135752127.dkr.ecr.us-east-1.amazonaws.com/emplicheck-beta-user-frontend:latest"] 
    container_mount_path = "/mnt/efs"
    container_port = 80
    cpu = 256
    container_memory = 256 
    family = ["api","admin","landing","emplicheck-beta-user-frontend"]
    container_name = ["api","admin","landing","emplicheck-beta-user-frontend"]
    service_name  = ["api","admin","landing","emplicheck-beta-user-frontend"]
    service_desired_count= [2,1,1,1]
    scalable_dimension  = ["ecs:service:DesiredCount","ecs:service:DesiredCount","ecs:service:DesiredCount","ecs:service:DesiredCount"]
    service_namespace = ["ecs","ecs","ecs","ecs"]

  }
 }
################################################################Target Group################################

 variable "tg_vars" {
  description = "target group Variables define an ECS task."
  type = object({
    healthy_threshold = string,
    interval  = string,
    matcher = list(string),
    path    = list(string),
    protocol = list(string),
    service_name = list(string)
    timeout = string
    unhealthy_threshold = string
  })
  default = {
    healthy_threshold = "2"
    interval = "60"
    matcher = ["200","200","200","200"]
    path = [ "/","/","/","/" ]
    protocol = ["HTTP","HTTP","HTTP","HTTP"]
    service_name = ["api","admin","landing","emplicheck-beta-user-frontend"]
    timeout = "50"
    unhealthy_threshold = "5"
  }
 }
################################################################listener_vars################################

variable "listener_vars" {
  description = "Listener variables define an ECS task."
  type = object({
    service_name = list(string)
    priority = list(number)
    service_path = list(string)
    service_domain = list(string)
    
  })
  default = {
    priority       = [ 96,97,98,99]
    service_domain = ["api.beta.emplicheck.com","beta.emplicheck.com","beta.emplicheck.com","beta.emplicheck.com"]
    service_name   = ["api","admin","landing","emplicheck-beta-user-frontend"]
    service_path   = ["api","u","admin","landing"]
  } 
}

variable "create_tasks" {
  type    = list(any)
    default = ["true","true","true","true"]
}

variable "cloudwatch_group" {
  type    = string
  default = "/ecs/container/"
}

################################################################EFS Volume################################
variable "efs_sys_id" {
  type    = string
  default = "fs-0b16b51786986cf4d"
  # default = "fs-04884e9e57f8b9e82"

}

variable "access_point_id" {
  type    = string
  default = "fsap-0d9850a7c1837ce5b"
  # default =  "fsap-0af3e4c4e6cb45dcc"s
}


################################################################Target Group################################

# variable "health_check" {
#   type = list(object({
#     # healthy_threshold   = number
#     # interval            = number
#     # matcher             = string
#     # path                = string
#     # port                = number
#     # protocol            = string
#     # timeout             = number
#     # unhealthy_threshold = number
#     healthy_threshold   = [2,2,2]
#     interval            = [13,13,13]
#     matcher             = ["200","200","200"]
#     path                = ["/status","/status","/status"]
#     port                = [80,80,80]
#     protocol            = ["HTTP","HTTP","HTTP"]
#     timeout             = [6,6,6]
#     unhealthy_threshold = [5,5,5]
#   }))
# }


