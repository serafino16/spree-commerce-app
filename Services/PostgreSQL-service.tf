resource "kubernetes_service_account" "postgres" {
  metadata {
    name      = "postgres-sa"
    namespace = "spree"
  }
}

resource "kubernetes_service" "postgres_headless" {
  metadata {
    name      = "postgres"
    namespace = "spree"
  }
  nnotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "internal"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internal"
    }

  spec {
    cluster_ip = "None" 
    selector = {
      app = "postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = "postgres"
    namespace = "spree"
  }

  spec {
    service_name = "postgres"
    replicas     = 2

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.postgres.metadata[0].name

        container {
          name  = "postgres"
          image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/postgresql:13"

          env {
            name  = "POSTGRES_DB"
            value = "spree"
          }
          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password"
          }

          ports {
            container_port = 5432
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1Gi"
              memory = "1Gi"
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
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres"
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", "admin"]
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "admin"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgres-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "20Gi"
          }
        }
      }
    }
  }
}
resource "kubernetes_manifest" "vpa_postgres" {
  manifest = {
    apiVersion = "autoscaling.k8s.io/v1"
    kind       = "VerticalPodAutoscaler"
    metadata = {
      name      = "postgres-vpa"
      namespace = "spree"
    }
    spec = {
      targetRef = {
        apiVersion = "apps/v1"
        kind       = "StatefulSet"
        name       = "postgres"
      }
      updatePolicy = {
        updateMode = "Auto"
      }
    }
  }
}
resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = "spree"  
  }

  data = {
    POSTGRES_DB       = "mydatabase"
    POSTGRES_USER     = "myuser"
    POSTGRES_PASSWORD = "mypassword"
  }

  type = "Opaque"
}

