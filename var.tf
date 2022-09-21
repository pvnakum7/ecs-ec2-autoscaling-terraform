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
  default = "2lc.tech"
}

variable "site_domain_name" {
  default = "dev.2lc.tech"
}
variable "zone_id" {
  default = "Z08187652TPA8ZWLMHNDL"
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


#################################################Task Defination ###############################################
# variable "ecs_tasks" {
#   description = "Map of variables to define an ECS task."
#   type = map(object({
#     # family               = string
#     family               = "frontend"
#     name                 = "frontend"
#     # container_definition = string
#     # container_definition  = file(task-definitions/containerDefinitions.json)
#     cpu                  = 100
#     memory               = 512
#     container_image      = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#     # container_port       = string
#     container_port       = 80
#     host_port            = 0
#     network_mode         = "bridge"
#   },{
#    # family               = string
#     family               = "api"
#     name                 = "api"
#     cpu                  = 100
#     memory               = 512
#     container_image      = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#     # container_port       = string
#     container_port       = 80
#     host_port            = 0
#     network_mode         = "bridge"
#   },{
#    # family               = string
#     family               = "admin"
#     name                 = "admin"
#     cpu                  = 100
#     memory               = 512
#     container_image      = "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"
#     # container_port       = string
#     container_port       = 80
#     host_port            = 0
#     network_mode         = "bridge"
#   }
   
#   ))
# }
 
 
variable "ecs_tasks" {
  type    = list(string)
  default = ["frontend","api","admin"]
  # ,"landing","html", "adfrontend","esign","mq","oms","cron","docs"]
}

variable "service_list" {
  type    = list(string)
  default = ["frontend","api","admin"]
  # ,"landing","html", "adfrontend","esign","mq","oms","cron","docs"]
}

variable "container_name" {
  type    = list(string)
  default = ["frontend","api","admin"]
  # ,"landing","html", "adfrontend","esign","mq","oms","cron","docs"]
}

variable "service_path" {
  type    = list(string)
  default = ["frontend","api","admin"]
  # ,"landing","html", "adfrontend","esign","mq","oms","cron","docs"]
}
variable "service_domain" {
  type    = list(string)
  default = ["dev.2lc.com","dev.2lc.com","dev.2lc.com"]
  # ,"landing","html", "adfrontend","esign","mq","oms","cron","docs"]
}

variable "container_port" {
  description = "An Container port block"
  type    = list(any)
  default = [80,80,80]
  # ,"80","80","80","80","80","80","80","80"]  
}


variable "container_images" {
  type    = list(string)
  default = ["918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest", "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest", "918135752127.dkr.ecr.us-east-1.amazonaws.com/helloword:latest"] 
  # , "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev", "seguridad-be-dev"]
}

variable "create_tasks" {
  type    = list(any)
    default = ["true","true","true"]
}

################################################################Target Group################################

variable "healthy_threshold" {
  type    = list(any)
  default = [2,2,2]
}

variable "interval" {
  type    = list(string)
  default = [13,13,13]
}

variable "matcher" {
  type    = list(string)
  default = ["200","200","200"]
}

variable "path" {
  type    = list(string)
  # default = ["/health_status","/health_status","/health_status"]
  default = ["/","/","/"]
}

variable "port" {
  type    = list(string)
  default = [80,80,80]
}

variable "protocol" {
  type    = list(string)
  default = ["HTTP","HTTP","HTTP"]
}
variable "timeout" {
  type    = list(string)
  default = [6,6,6]
}
variable "unhealthy_threshold" {
  type    = list(string)
  default = [5,5,5]
}

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




variable "scalable_dimension" {
  type    = list(string)
  default = ["ecs:service:DesiredCount","ecs:service:DesiredCount","ecs:service:DesiredCount"]
}

variable "service_namespace" {
  type    = list(string)
  default = ["ecs","ecs","ecs"]
}
