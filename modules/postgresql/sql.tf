resource "random_id" "this" {
  count       = var.init_custom_sql_script != "" ? 1 : 0
  byte_length = 4
}
resource "google_storage_bucket" "script" {
  #checkov:skip=CKV_GCP_62:Access logging not required for this bucket
  count                       = var.init_custom_sql_script != "" ? 1 : 0
  name                        = "sql-script-${random_id.this[0].hex}"
  location                    = "europe-west3"
  force_destroy               = true
  project                     = var.project_id
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_object" "sql_script" {
  count   = var.init_custom_sql_script != "" ? 1 : 0
  name    = "script.sql"
  bucket  = google_storage_bucket.script[0].name
  content = var.init_custom_sql_script
}

resource "google_storage_bucket_iam_member" "script_access" {
  count  = var.init_custom_sql_script != "" ? 1 : 0
  bucket = google_storage_bucket.script[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.postgresql_db.instance_service_account_email_address}"
}

resource "terraform_data" "sql_script" {
  count = var.init_custom_sql_script != "" ? 1 : 0
  triggers_replace = [
    google_storage_bucket.script[0].name,
    module.postgresql_db.instance_name
  ]
  provisioner "local-exec" {
    command = "gcloud sql import sql ${module.postgresql_db.instance_name} gs://${google_storage_bucket.script[0].name}/script.sql --database=postgres --project=${var.project_id} -q"
  }
}
