# You need to create a service account for each project that requires customer-managed encryption keys.
resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}

# Grant access to the key
resource "google_kms_crypto_key_iam_member" "crypto_key" {
  provider = google-beta

  crypto_key_id = var.encryption_key_id == null ? google_kms_crypto_key.this[0].id : var.encryption_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  member = "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}"
}

# Create key if not provided
module "key_ring" {
  source = "../key-ring"

  key_ring_name          = "gke-${var.name}-keyring"
  project_id             = coalesce(var.key_ring_project_id, var.project_id)
  existing_key_ring_name = var.key_ring_name
  key_ring_location      = var.region
}

resource "google_kms_crypto_key" "this" {
  count = var.encryption_key_id == null ? 1 : 0

  name     = "${var.name}-key"
  key_ring = module.key_ring.key_ring.id

  #checkov:skip=CKV_GCP_43:Ensure GCP KMS encryption key is rotating every 90 days
  # Skipped because it's a variable so the linter doesn't know the rotation period.
  rotation_period = var.encryption_key_rotation_period

  # CKV_GCP_82: "Ensure KMS keys are protected from deletion"
  lifecycle {
    prevent_destroy = true
  }
}
