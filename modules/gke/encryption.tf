module "key_ring" {
  source = "../key-ring"

  key_ring_name          = "gke-${var.name}-keyring"
  project_id             = coalesce(var.key_ring_project_id, var.project_id)
  existing_key_ring_name = var.key_ring_name
  key_ring_location      = replace(var.location, "/-[a-d]/", "")
}

# create a random_id to suffix `google_kms_crypto_key.this`
# useful because kms
resource "random_id" "kms_key" {
  byte_length = 3
  prefix      = "gke-${var.name}-key-"
}

resource "google_kms_crypto_key" "this" {
  #checkov:skip=CKV_GCP_82:Ensure KMS keys are protected from deletion
  #checkov:skip=CKV_GCP_43:Ensure KMS encryption keys are rotated within a period of 90 days
  name                       = random_id.kms_key.hex
  key_ring                   = module.key_ring.key_ring.id
  rotation_period            = "7890000s" # 3 months
  destroy_scheduled_duration = "604800s"  # 7 days

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
}

# Binding for KMS Key encryption and decryption
resource "google_project_service_identity" "container" {
  provider = google-beta

  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "container_crypto_key" {
  crypto_key_id = local.kms_key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.container.email}"
}

resource "google_project_iam_member" "compute_crypto" {
  project = var.project_id

  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  # 23/12/2022: we can not use the service identity resource as it is not available for compute google api yet,
  # Instead we need to build the email using the project ID
  member = "serviceAccount:service-${data.google_project.this.number}@compute-system.iam.gserviceaccount.com"
}
