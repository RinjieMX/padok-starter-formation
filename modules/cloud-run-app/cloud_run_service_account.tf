
module "service_account" {
  source       = "../service-account"
  name         = var.name
  project_id   = var.project_id
  display_name = "Service Account for ${var.name} Cloud Run Application"

  project_roles          = var.service_account.project_roles
  external_project_roles = var.service_account.external_project_roles
  bucket_roles           = var.service_account.bucket_roles
  secret_roles           = var.service_account.secret_roles
  service_account_roles  = var.service_account.service_account_roles
}

resource "google_storage_bucket_iam_member" "this" {
  for_each = var.buckets
  bucket   = google_storage_bucket.this[each.key].id
  role     = "roles/storage.admin"
  member   = "serviceAccount:${module.service_account.this.email}"
}
