resource "google_storage_bucket" "this" {
  #checkov:skip=CKV_GCP_62:Bucket should log access
  # Skipped because we don't have a variable for log bucket currently.
  name          = "${var.name}-exports"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  # CKV_GCP_78: Ensure Cloud storage has versioning enabled
  versioning {
    enabled = true
  }

  # CKV_GCP_114: Ensure public access prevention is enforced on Cloud Storage bucket
  public_access_prevention = "enforced"

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age = lifecycle_rule.value.condition.age
      }
      action {
        type          = "SetStorageClass"
        storage_class = lifecycle_rule.value.action.storage_class
      }
    }
  }
}

module "pubsub" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_GCP_42: Module uses the storage.admin role
  source              = "terraform-google-modules/pubsub/google"
  version             = "~> 7.0"
  topic               = "${var.name}-exporter"
  project_id          = var.project_id
  grant_token_creator = false
}

resource "google_service_account" "this" {
  account_id = "${var.name}-exporter"
  project    = var.project_id
}

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.this.email}"
}


resource "google_project_iam_member" "this" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.this.email}"
}

resource "random_id" "suffix" {
  byte_length = 4
}


module "function" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_GCP_78:Ensure Cloud storage has versioning enabled
  #checkov:skip=CKV_GCP_114:Ensure public access prevention is enforced on Cloud Storage bucket
  #checkov:skip=CKV2_GCP_10:Ensure GCP Cloud Function HTTP trigger is secured
  # Skipped because it doesn't need to be an option in the module below.
  source  = "terraform-google-modules/event-function/google"
  version = "~> 4.1.0"

  entry_point = "ProcessPubSub"
  event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource   = module.pubsub.id
  }
  name             = "${var.name}-exporter"
  project_id       = var.project_id
  region           = var.region
  runtime          = "go118"
  source_directory = "${path.module}/function"

  source_dependent_files = []

  available_memory_mb                = 256
  bucket_force_destroy               = true
  bucket_name                        = "${var.name}-scheduled-exporter-function-${random_id.suffix.hex}"
  description                        = "Function to backup SQL instance."
  event_trigger_failure_policy_retry = false
  service_account_email              = google_service_account.this.email
  timeout_s                          = 540

  ingress_settings = "ALLOW_INTERNAL_ONLY"
}
