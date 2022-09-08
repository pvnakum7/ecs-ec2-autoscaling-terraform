resource "aws_route53_record" "dev" {

    depends_on = [module.alb]
    zone_id = var.zone_id
    name    =  "dev"       #var.site_domain_name
    type    = "A"
    
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}



# resource "aws_route53_record" "dev" {
#     depends_on = [module.alb]
#     zone_id = var.zone_id
#     name    =  "dev"             #"var.site_domain_name"
#     type    = "CNAME"
#     ttl     = 300

#     records = [module.alb.lb_dns_name]
# }