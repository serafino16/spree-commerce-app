
data "http" "efs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json"

  
  request_headers = {
    Accept = "application/json"
  }
}

output "efs_csi_iam_policy" {
  value = data.http.efs_csi_iam_policy.body
}