locals {
  # TODO: When out of beta use google_project_service_identity resource directly
  cloud_run_project_service_identity = "service-${data.google_project.this.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

data "google_project" "this" {
  project_id = var.project_id
}

resource "google_project_iam_member" "cloudrun_gcr" {
  for_each = toset(var.registry_project_ids)
  project  = each.key
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${local.cloud_run_project_service_identity}"
}

resource "google_project_iam_member" "cloudrun_artifact_registry" {
  for_each = toset(var.registry_project_ids)
  project  = each.key
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${local.cloud_run_project_service_identity}"
}

resource "google_project_iam_member" "cloudrun_vpcaccess" {
  project = var.host_project_id
  role    = "roles/vpcaccess.user"
  member  = "serviceAccount:${local.cloud_run_project_service_identity}"
}
