# Example of code for deploying a private PostgreSQL DB with a peering between your private subnet and cloudsql service.
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

  name       = "my-network-1"
  project_id = local.project_id

  subnets = {
    "my-private-subnet-1" = {
      name             = "my-private-subnet-1"
      region           = "europe-west3"
      primary_cidr     = "10.30.0.0/16"
      serverless_cidr  = ""
      secondary_ranges = {}
    }
  }
  gcp_peering_cidr = "10.0.17.0/24"
}

module "my-sql-exporter" {
  source = "../.."

  name = "my-exporter-2"

  project_id = local.project_id
  region     = "europe-west3"
  depends_on = [module.my_network.google_service_networking_connection]
}


module "my-private-postgresql-db" {
  source = "../../../postgresql"

  name              = "my-private-postgres-db1" # Mandatory
  engine_version    = "POSTGRES_11"             # Mandatory
  project_id        = local.project_id          # Mandatory
  region            = "europe-west1"            # Mandatory
  availability_type = "REGIONAL"
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
  }

  databases = {
    "MYDB_1" = {
      export_backup   = true
      export_schedule = "0 5 * * *"
    }
    "MYDB_2" = {
      export_backup   = true
      export_schedule = "0 8 * * *"
    }
    "MYDB_3" = {
      export_backup = false
    }
  }

  private_network = module.my_network.network_id
  depends_on      = [module.my_network.google_service_networking_connection]
}
