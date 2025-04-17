resource "google_project_service_identity" "composer_service_identity" {
  provider = google-beta

  project = var.composer_project_id
  service = "composer.googleapis.com"
}

resource "google_project_iam_binding" "composer_shared_vpc" {
  project = var.host_project_id
  role    = "roles/composer.sharedVpcAgent"

  members = [
    "serviceAccount:${google_project_service_identity.composer_service_identity.email}",
  ]
}
