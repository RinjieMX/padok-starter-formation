module "redis" {
  for_each = { for k, x in var.redis : k => x }

  #checkov:skip=CKV_TF_1:Version setup in the destination module
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 12.0"

  name               = each.key
  project_id         = var.project_id
  region             = var.location
  tier               = each.value.tier
  memory_size_gb     = each.value.memory
  redis_version      = each.value.version
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  reserved_ip_range  = var.network.gcp_peering_connection
  authorized_network = trimprefix(var.network.resource_link, local.google_compute_apis_url)
  auth_enabled       = true
}
