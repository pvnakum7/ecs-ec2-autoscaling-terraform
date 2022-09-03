provider "aws" {
  region = var.region
  profile = "2cl"
  # alias = "acm"
  }
data "aws_availability_zones" "available" {
  state = "available"
}
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6"
    }
  }
#   backend "s3" {
#     bucket = "${var.s3bucketname}"
#     key    = "./privatekey.pem"
#     region = "us-east-1"
#   }
}

locals {
  name   = "${var.service_name}"
  
  tags = {
    Owner       = "Owner"
    Environment = var.env
    Name        = var.service_name
  }
}