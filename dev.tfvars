#example : fill your information
variable "region" {
  default = "us-east-1"
}
 variable "accountid" {
  type        = string
  default     = "aws account id"
 }

provider "aws" {
  # access_key = ""
  # secret_key = ""
  region     = "${var.region}"
}
variable "s3bucketname"{
  type        = string
  default     = "simulator-test"
}

variable "vpc_name"{
  type        = string
  default     = "vpc-${var.service_name}-${var.env}"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "192.31.0.0/16"
}
variable "azones"{
  type        = list(string)
  default     = ["${var.region}a", "${var.region}b","${var.region}c"]  
}

variable "public_subnet" {
  description = "Assigns IPv4 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = ["192.31.1.0/20","192.31.16.0/20"]
}

variable "private_subnet" {
  description = "Assigns IPv4 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = ["192.31.32.0/20","192.31.48.0/20"]
}

variable "kms_key_id" {
  type =  string
  default = ""
  description = "kmsemplicheck"
}
variable "aws_account_id" {
  default = "abcd242212"
}

variable "service_name" {
  default = "emplicheck"
}
variable "env" {
  default = "dev"
}






