module "gke" {
  source     = "../gke"
  name       = var.context.gke.name
  project_id = var.context.project_id

  location = var.context.gke.location

  registry_project_ids = var.context.gke.registry_project_ids

  network    = var.context.gke.network
  node_pools = var.context.gke.node_pools

  key_ring_name       = try(var.context.kms.key_ring_name, "")
  key_ring_project_id = try(var.context.kms.key_ring_project_id, "")
}
