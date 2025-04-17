locals {
  google_compute_apis_url = "https://www.googleapis.com/compute/v1/"
  zone                    = random_shuffle.zone.result[0]
}

# Select a zone randomly
resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.this.names
  result_count = length(data.google_compute_zones.this.names)
}

module "sql" {
  for_each = { for k, x in var.databases : k => x }
  source   = "../postgresql"

  name              = each.key
  engine_version    = each.value.engine_version
  project_id        = var.project_id
  region            = var.location
  availability_type = each.value.availability_type
  zone              = local.zone

  disk_limit = 20

  users          = [var.name]
  create_secrets = true

  backup_configuration = {
    enabled  = true
    location = each.value.backup_region
  }

  databases = {
    (var.name) = {
      export_backup = false
    }
  }

  private_network    = trimprefix(var.network.resource_link, local.google_compute_apis_url)
  allocated_ip_range = var.network.gcp_peering_connection
}
