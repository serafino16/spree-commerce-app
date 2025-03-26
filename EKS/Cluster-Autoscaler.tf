 
data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}


provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


resource "kubernetes_manifest" "cluster_autoscaler_rbac" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      name = "cluster-autoscaler"
    }
    rules = [
      {
        apiGroups = [""],
        resources = ["events", "endpoints"],
        verbs     = ["create", "patch"]
      },
      {
        apiGroups = [""],
        resources = ["pods/eviction"],
        verbs     = ["create"]
      },
      {
        apiGroups = [""],
        resources = ["pods", "nodes"],
        verbs     = ["get", "list", "watch"]
      },
      {
        apiGroups = ["autoscaling"],
        resources = ["verticalpodautoscalers"],
        verbs     = ["get", "list"]
      }
    ]
  }
}

resource "kubernetes_manifest" "cluster_autoscaler_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "cluster-autoscaler"
      namespace = "kube-system"
      labels = {
        app = "cluster-autoscaler"
      }
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "cluster-autoscaler"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "cluster-autoscaler"
          }
        }
        spec = {
          serviceAccountName = "cluster-autoscaler"
          containers = [
            {
              name  = "cluster-autoscaler"
              image = "registry.k8s.io/autoscaler/cluster-autoscaler:v1.29.0"
              command = [
                "cluster-autoscaler",
                "--v=4",
                "--stderrthreshold=info",
                "--cloud-provider=aws",
                "--skip-nodes-with-local-storage=false",
                "--expander=least-waste",
                "--scale-down-enabled=true",
                "--balance-similar-node-groups"
              ]
              volumeMounts = [
                {
                  name       = "ssl-certs"
                  mountPath  = "/etc/ssl/certs"
                  readOnly   = true
                }
              ]
            }
          ]
          volumes = [
            {
              name = "ssl-certs"
              hostPath = {
                path = "/etc/ssl/certs"
              }
            }
          ]
        }
      }
    }
  }
}
