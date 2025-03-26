resource "aws_lb" "nlb_internal" {
  name               = "spree-nlb-internal"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = var.private_subnets
}

resource "aws_lb_target_group" "tg_core" {
  name     = "spree-core-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "tg_api" {
  name     = "spree-api-tg"
  port     = 8081
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "tg_payment" {
  name     = "spree-payment-tg"
  port     = 8082
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "tg_postgresql" {
  name     = "spree-db-tg"
  port     = 5432
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "tg_redis" {
  name     = "spree-redis-tg"
  port     = 6379
  protocol = "TCP"
  vpc_id   = var.vpc_id
}
