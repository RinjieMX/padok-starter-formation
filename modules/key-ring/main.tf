data "google_kms_key_ring" "this" {
  count = var.existing_key_ring_name != "" ? 1 : 0

  project  = var.project_id
  name     = var.existing_key_ring_name
  location = var.key_ring_location
}

resource "google_kms_key_ring" "this" {
  count = var.existing_key_ring_name == "" ? 1 : 0

  project  = var.project_id
  name     = var.key_ring_name
  location = var.key_ring_location
}
