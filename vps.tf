
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "vpc-${var.service_name}-${var.env}"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
#  azs             = var.azone
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet

  enable_nat_gateway = true
  #enable_vpn_gateway = true
  create_igw  = true
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
