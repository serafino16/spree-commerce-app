resource "kubernetes_ingress_v1" "alb_ingress" {
  metadata {
    name      = "alb-ingress"
    namespace = "spree"
    annotations = {
      "kubernetes.io/ingress.class"                     = "alb"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"          = "ip"
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn"      = "arn:aws:acm:us-east-1:123456789012:certificate/your-cert-id"
      "alb.ingress.kubernetes.io/ssl-redirect"         = "443"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds"  = 15
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = 5
      "alb.ingress.kubernetes.io/success-codes"  = 200
      "alb.ingress.kubernetes.io/healthy-threshold-count"  = 2
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"  = 2
      
    }
  }

  spec {
    rule {
      host = "frontend.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "core.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-core"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

