resource "kubernetes_namespace" "spree" {
  metadata {
    name = "spree"
  }
}
