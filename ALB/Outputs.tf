output "alb_dns" {
  value = aws_lb.alb_external.dns_name
}