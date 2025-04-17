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
  source = "../../../network"

  name       = "my-network-6"
  project_id = local.project_id

  subnets = {
    "my-private-subnet-3" = {
      name             = "my-private-subnet-6"
      region           = "europe-west3"
      primary_cidr     = "10.35.0.0/16"
      serverless_cidr  = ""
      secondary_ranges = {}
    }
  }
  gcp_peering_cidr = "10.0.22.0/24"
}

module "my-sql-exporter" {
  source = "../.."

  name = "my-exporter-1"

  project_id = local.project_id
  region     = "europe-west3"
  depends_on = [module.my_network.google_service_networking_connection]
}

module "my-public-mysql-db-with-backup" {
  source = "../../../mysql"

  name              = "my-public-mysql-db2" # Mandatory
  engine_version    = "MYSQL_8_0"           # Mandatory
  project_id        = local.project_id      # Mandatory
  region            = "europe-west1"        # Mandatory
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

  sql_exporter = {
    bucket_name  = module.my-sql-exporter.bucket_name
    pubsub_topic = module.my-sql-exporter.pubsub_topic
    timezone     = "UTC+1"
  }

  databases = {
    "MYDB_1" = {
      export_backup   = true
      export_schedule = "0 3 * * *"
    }
  }

  private_network = module.my_network.network_id
  depends_on      = [module.my_network.google_service_networking_connection]

  public = true
}
