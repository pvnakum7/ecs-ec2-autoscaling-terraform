provider "aws" {
  region = var.region
  profile = "2lc"
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
  backend "s3" {
    bucket         = "twolc-tech-dev"
    # key    = "./dev-emplicheck.pem"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    profile        = "2lc"
    # encrypt        = true
    # kms_key_id     = "alias/terraform_bucket_2lc_key"
      # dynamodb_table = "cliemterraform-state"
  }
}

locals {
  name   = "${var.service_name}"
  
  tags = {
    Owner       = "Owner"
    Environment = var.env
    Name        = var.service_name
  }
}

# data "aws_ami" "amazon2" {
#   most_recent = true
#   owners = ["amazon"]  
#   filter {
#     name = "name"
#     values = ["amzn2-ami-*-hvm-*-arm64-gp2"]
#   }

#   filter {
#     name = "architecture"
#     values = ["arm64"]
#   }
# }

# Get latest Ubuntu Linux Focal Fossa 20.04 AMI
data "aws_ami" "linuxami" {
  most_recent = true
  # owners      = ["Canonical"] # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  # filter {
  #   name   = "Platform"
  #   values = ["ubuntu"]
  # }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 }
output "Linux_AMI" {
  value = data.aws_ami.linuxami
}


  