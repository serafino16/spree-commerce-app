provider "aws" {
  region = "us-east-1"
}


resource "aws_route53_zone" "public_zone" {
  name = "www.spree.com"  
}


resource "aws_route53_zone" "private_zone" {
  name = "spree-internal.com"  
  vpc {
    vpc_id = "vpc-345"  
  }
}
