resource "kubernetes_service_account" "spree_frontend" {
  metadata {
    name      = "spree-frontend-sa"
    namespace = "spree"
  }
}

resource "kubernetes_deployment" "spree_frontend" {
  metadata {
    name      = "spree-frontend"
    namespace = "spree"
    labels = {
      app = "spree-frontend"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "spree-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "spree-frontend"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.spree_frontend.metadata[0].name

        container {
          name  = "spree-frontend"
          image = "123456779012.dkr.ecr.us-east-1.amazonaws.com/node:16-alpine"

          ports {
            container_port = 8080
          }
          
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          
          readiness_probe {
            http_get {
              path = "/readyz"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

        }
      }
    }
  }
}
resource "kubernetes_service" "spree_frontend" {
  metadata {
    name      = "spree-frontend"
    namespace = "spree"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                = "external"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"              = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-target-group-attributes" = "stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=600"
      "external-dns.alpha.kubernetes.io/hostname" = "www.spree-commerce.com"
    }
  }

  spec {
    selector = {
      app = "spree-frontend"
    }
    

    type = "LoadBalancer"  

    port {
      protocol    = "TCP"
      port        = 80  
      target_port = 3000  
    }

    port {
      protocol    = "TCP"
      port        = 443  
      target_port = 3000  
    }
  }
}
