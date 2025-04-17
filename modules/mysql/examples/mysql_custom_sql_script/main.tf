# Example of code for deploying a private MySQL DB with a peering between your private subnet and cloudsql service.
# To access to your DB, you need a bastion or a VPN connection from your client.
locals {
  project_id = "gcp-library-terratest"
}

provider "google" {
  project = local.project_id
  region  = "europe-west3"
}

provider "google-beta" {
  project = local.project_id
  region  = "europe-west3"
}

module "my_network" {
  #checkov:skip=CKV_TF_1: we decided to be somehow flexible with versions and we cannot add a precise commit sha
  source = "github.com/padok-team/terraform-google-network.git?ref=1f769d3d73525cd72c102607809fbebbf331edba" # v4.3.0

  name       = "my-network-13"
  project_id = local.project_id

  subnets = {
    "my-private-subnet-3" = {
      name             = "my-private-subnet-3"
      region           = "europe-west3"
      primary_cidr     = "10.32.0.0/16"
      serverless_cidr  = ""
      secondary_ranges = {}
    }
  }
  gcp_peering_cidr = "10.0.19.0/24"
}

module "my-private-mysql-db" {
  source = "../.."

  name              = "my-private-mysql-db13" # Mandatory
  engine_version    = "MYSQL_8_0"             # Mandatory
  project_id        = local.project_id        # Mandatory
  region            = "europe-west1"          # Mandatory
  availability_type = "ZONAL"
  zone              = "europe-west1-b"

  disk_limit = 20

  users          = ["User_1", "User_2"]
  create_secrets = true

  backup_configuration = {
    enabled  = true
    location = "europe-west3"

    #checkov:skip=CKV2_GCP_20:Ensure MySQL DB instance has point-in-time recovery backup configured
    #Skipped because we don't have a 'start_time' within the backup_configuration
  }

  databases = {
    "MYDB_1" = {
      export_backup = false
    }
  }

  private_network = module.my_network.network_id
  depends_on      = [module.my_network.google_service_networking_connection]

  init_custom_sql_script = <<EOT
GRANT ALL PRIVILEGES ON MYDB_1.* TO 'User_1'@'';
EOT
}
