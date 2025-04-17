# --- Deploy frontend --- #
module "frontend" {
  source     = "../staticfrontend"
  name       = var.name
  project_id = var.project_id
  location   = var.region

}
