resource "aws_route53_record" "payment_internal" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "spree-payment.internal.com"  
  type    = "A"
  ttl     = 60
  records = ["10.0.0.10"]  
}

resource "aws_route53_record" "core_internal" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "spree-core.internal.com"  
  type    = "A"
  ttl     = 60
  records = ["10.0.0.11"]  
}

resource "aws_route53_record" "postgres_internal" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "postgres.internal.com"  
  type    = "A"
  ttl     = 60
  records = ["10.0.0.12"]  
}
