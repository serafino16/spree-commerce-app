


resource "kubernetes_service_account" "spree_payment" {
  depends_on = [ aws_iam_role_policy_attachment.irsa_iam_role_policy_attach ]
  metadata {
    name      = "spree-payment-sa"
    namespace = "spree"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_iam_role.arn
      }
  }
}


resource "kubernetes_deployment" "spree_payment" {
  metadata {
    name      = "spree-payment"
    namespace = "spree"
    labels = {
      app = "spree-payment"
    }
  }

  spec {
    replicas = 2  
    selector {
      match_labels = {
        app = "spree-payment"
      }
    }

    template {
      metadata {
        labels = {
          app = "spree-payment"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.spree_payment.metadata[0].name

        container {
          name  = "spree-payment"
          image = "123455789012.dkr.ecr.us-east-1.amazonaws.com/ruby:3.1.0-alpine"  

          
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

          
          volume_mount {
            name       = "efs-storage"
            mount_path = "/app/storage"
          }
        }

        
        volume {
          name = "efs-storage"

          persistent_volume_claim {
            claim_name = "efs-pvc"
          }
        }
      }
    }
  }
}



resource "kubernetes_service" "spree_payment" {
  metadata {
    name      = "spree-payment"
    namespace = "spree"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "internal"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internal"
    }
  }

  spec {
    selector = {
      app = "spree-payment"
    }

    type = "LoadBalancer"

    port {
      protocol    = "TCP"
      port        = 443
      target_port = 443
    }
  }
}
