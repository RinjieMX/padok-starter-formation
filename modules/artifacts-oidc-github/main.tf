# Artifact repository
resource "google_artifact_registry_repository" "docker" {
  #checkov:skip=CKV_GCP_84: TODO later (encrypted with Customer Supplied Encryption Keys)
  project       = var.context.project_id
  location      = var.context.region
  repository_id = var.context.gcp_repo_name
  description   = "Docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

module "github_oidc" {
  source = "../oidc-github"

  project_id          = var.context.project_id
  github_orga_name    = var.context.github_orga_name
  github_repo_name    = var.context.github_repo_name
  attribute_condition = var.context.conditions

  workload_identity_pool_id          = "github-pool"
  workload_identity_pool_provider_id = "github-pool-provider"

  create_service_account      = true
  service_account_github_name = "github-pool"
}

resource "google_project_iam_binding" "iam_github_artifactregistry" {
  project = var.context.project_id
  role    = "roles/artifactregistry.writer"

  members = [
    "serviceAccount:${module.github_oidc.service_account_github_email}",
  ]
}

data "google_compute_default_service_account" "default" {
  project = var.context.project_id
}

resource "google_service_account_iam_binding" "sa_github_iam_cloudrun" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${module.github_oidc.service_account_github_email}",
  ]
}

#The following is only usefull if you want to deploy a cloud run service otherwise you can remove it
resource "google_project_iam_binding" "iam_github_cloudrun" {
  project = var.context.project_id
  role    = "roles/run.admin"

  members = [
    "serviceAccount:${module.github_oidc.service_account_github_email}",
  ]
}