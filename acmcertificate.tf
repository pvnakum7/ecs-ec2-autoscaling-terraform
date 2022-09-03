provider "aws" {
  alias = "route53"
}
provider "aws" {
  alias = "acm"
}


module "acm" {
  source = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"
  providers = {
    aws = aws.acm
  }
  # providers = {
  #   aws.acm = aws,
  #   aws.dns = aws
  # }
  domain_name = var.domain_name
  zone_id     = var.zone_id

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  tags = {
    Name = var.domain_name
  }
}

module "acm_only" {
  source = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"
  # providers = {
  #   aws = aws.acm
  # }

  domain_name = var.domain_name
  subject_alternative_names = [
    "*.alerts.${var.domain_name}"
    # ,
    # "new.sub.separated.${var.domain_name}",
    # "*.separated.${var.domain_name}",
    # "alerts.separated.${var.domain_name}",
  ]

  create_route53_records  = true
  validation_record_fqdns = module.route53_records_only.validation_route53_record_fqdns
}

module "route53_records_only" {
  source = "terraform-aws-modules/acm/aws"
   providers = {
    aws = aws.route53
  }
  create_certificate          = false
  create_route53_records_only = true

  zone_id               = "${var.zone_id}"
  distinct_domain_names = module.acm_only.distinct_domain_names

  acm_certificate_domain_validation_options = module.acm_only.acm_certificate_domain_validation_options
}