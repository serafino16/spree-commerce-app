
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.public_zone.id
  name    = "spree-frontend.com"  
  type    = "A"
  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "admin" {
  zone_id = aws_route53_zone.public_zone.id
  name    = "www.admin.com"  
  type    = "A"
  alias {
    name                   = aws_lb.frontend_alb.dns_name  
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}

