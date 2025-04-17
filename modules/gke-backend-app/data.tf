data "google_compute_zones" "this" {
  project = var.project_id
  region  = data.google_compute_subnetwork.this[0].region
}
