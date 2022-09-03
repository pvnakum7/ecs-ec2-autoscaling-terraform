#example : fill your information
variable "region" {
  default = "us-east-1"
}
 variable "accountid" {
  type        = string
  default     = "aws-account-id"
 }

variable "s3bucketname"{
  type        = string
  default     = "simulator-test"
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

variable "kms_key_arn" {
  type =  string
  default = ""
  description = "kmsemplicheck"
}


variable "aws_account_id" {
  default = "abcd242212"
}

variable "service_name" {
  default = "Myecs"
}
variable "env" {
  default = "dev"
}

variable "instance_ami"{
  type =  string
  default = ""
  description = " Linux AMI"
}
variable "ec2instance_type"{
  type =  string
  default = "t3.micro"
  description = " instance type"
}

variable "use_fullname" {
  type        = bool
  description = "Set 'true' to use `namespace-stage-name` for ecr repository name, else `name`"
  default = true
}

# variable "principals" {
#   type        = map(list(string))
#   description = "Map of service name as key and a list of ARNs to allow assuming the role as value (e.g. map(`AWS`, list(`arn:aws:iam:::role/admin`)))"
#   default = map(list("role-arn1","role-arn2"))
# }


#################################################Route53 ###############################################
variable "domain_name" {
  default = "abcd.com"
}

variable "zone_id" {
  default = "sdbsjssjsff"
}


#################################################RDS ###############################################
variable "db_name" {
  default = "abcd.com"
}

variable "username" {
  default = "sdbsjssjsff"
}

variable "db_port" {
  default = "3306"
}
