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

variable "ec2instance_type"{
  type =  string
  default = "t3.micro"
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

variable "username" {
  default = ""
}

variable "password" {
default = ""
}
variable "db_port" {
  default = "3306"
}

variable "db_instancetype" {
  default = "db.t3.micro"
}
