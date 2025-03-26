resource "kubernetes_ingress_v1" "nlb_ingress" {
  metadata {
    name      = "nlb-ingress"
    namespace = "default"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-name" = "lbc-network-lb-internal"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "internal"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip" 
    
      
      
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol" = "http"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-port" = "traffic-port"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-path" = "/index.html"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-healthy-threshold" = 3
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-unhealthy-threshold" = 3
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval" = 10 

      
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internal" 
      
      "service.beta.kubernetes.io/load-balancer-source-ranges" = "0.0.0.0/0"  
      
      
      "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = "Environment=prod"
    }
  }

  spec {
    rule {
      host = "api.internal.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-api"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "payment.internal.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-payment"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "admin.internal.spree-admin.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-admin"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "db.internal.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "postgresql"
              port {
                number = 5432
              }
            }
          }
        }
      }
    }

    rule {
      host = "cache.internal.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "redis"
              port {
                number = 6379
              }
            }
          }
        }
      }
    }

    rule {
      host = "jobs.internal.spree-commerce.com"

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "spree-background-jobs"
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
