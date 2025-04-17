data "google_secret_manager_secret_version" "git_host_public_key" {
  secret = "git_host_public_key"
}
data "google_secret_manager_secret_version" "git_host_private_key" {
  secret = "git_host_private_key"
}

resource "google_secret_manager_secret_iam_binding" "binding" {
  project   = var.project_id
  secret_id = data.google_secret_manager_secret_version.git_host_private_key.secret
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${module.service_account.this.email}", "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
  ]
}

resource "google_service_account_iam_binding" "token_creator" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${module.service_account.this.email}"
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
  ]
}

resource "google_kms_key_ring" "keyring" {
  project = var.project_id

  provider = google-beta

  name     = "${var.name}-key-ring"
  location = var.region
}

resource "google_kms_crypto_key" "crypto_key" {
  provider = google-beta

  name     = "${var.name}-crypto-key"
  key_ring = google_kms_key_ring.keyring.id
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {

  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${module.service_account.this.email}", "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
  ]
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_dataform_repository" "this" {
  project         = var.project_id
  region          = var.region
  provider        = google-beta
  name            = "${var.name}_repository"
  display_name    = "${var.name}_repository"
  kms_key_name    = google_kms_crypto_key.crypto_key.id
  service_account = module.service_account.this.email

  git_remote_settings {
    url            = var.git_ssh_url
    default_branch = var.git_branch

    ssh_authentication_config {
      user_private_key_secret_version = data.google_secret_manager_secret_version.git_host_private_key.name
      host_public_key                 = data.google_secret_manager_secret_version.git_host_public_key.secret_data
    }
  }

  workspace_compilation_overrides {
    default_database = var.project_id
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.crypto_key_binding
  ]
}

resource "google_dataform_repository_release_config" "this" {
  provider = google-beta

  project    = var.project_id
  region     = var.region
  repository = google_dataform_repository.this.name

  name          = var.environment
  git_commitish = var.git_branch

  code_compilation_config {
    default_database = var.project_id
    default_location = "EU"
  }
}
