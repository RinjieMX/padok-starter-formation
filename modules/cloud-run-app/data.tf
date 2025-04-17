data "google_compute_zones" "this" {
  project = var.project_id
  region  = var.location
}
