
resource "kubernetes_config_map" "usermgmt_dbcreation_script" {
  metadata {
    name = "usermanagement-dbcreation-script"
  }

  data = {
    "mysql_usermgmt.sql" = <<EOT
DROP DATABASE IF EXISTS webappdb;
CREATE DATABASE webappdb;
EOT
  }
}