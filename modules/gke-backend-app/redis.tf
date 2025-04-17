module "redis" {
  #checkov:skip=CKV_GCP_95:Auth is managed by the module
  for_each = { for k, x in var.redis : k => x }

  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 12.0"

  name               = each.key
  project_id         = var.project_id
  region             = data.google_compute_subnetwork.this[0].region
  tier               = each.value.tier
  memory_size_gb     = each.value.memory
  redis_version      = each.value.version
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  reserved_ip_range  = var.network.gcp_peering_connection
  authorized_network = trimprefix(data.google_compute_subnetwork.this[0].network, local.google_compute_apis_url)
}
