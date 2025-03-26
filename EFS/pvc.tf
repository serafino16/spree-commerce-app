
resource "kubernetes_persistent_volume_claim" "efs_pvc" {
  metadata {
    name      = "efs-pvc"
    namespace = "spree"
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }

    volume_name = "efs-pv"
  }
}