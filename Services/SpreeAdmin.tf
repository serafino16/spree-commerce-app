resource "kubernetes_service_account" "spree_admin" {
  depends_on = [ aws_iam_role_policy_attachment.irsa_iam_role_policy_attach ]
  metadata {
    name      = "spree-admin-sa"
    namespace = "spree"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_iam_role.arn
      }
  }
}

resource "kubernetes_deployment" "spree_admin" {
  metadata {
    name      = "spree-admin"
    namespace = "spree"
    labels = {
      app = "spree-admin"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "spree-admin"
      }
    }

    template {
      metadata {
        labels = {
          app = "spree-admin"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.spree_admin.metadata[0].name

        container {
          name  = "spree-admin"
          image = "123456789112.dkr.ecr.us-east-1.amazonaws.com/ruby:3.1.0-alpine"

          ports {
            container_port = 4000
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


          env {
            name  = "DATABASE_URL"
            value = "postgres://admin:password@postgres:5432/spree"
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
resource "kubernetes_service" "spree_admin" {
  metadata {
    name      = "spree-admin"
    namespace = "spree"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "internal"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internal"
    }
  }

  spec {
    selector = {
      app = "spree-admin"
    }

    type = "LoadBalancer"

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
  }
}
