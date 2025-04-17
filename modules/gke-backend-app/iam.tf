locals {
  bucket_roles = [for k, x in var.buckets : "${x.name}=>roles/storage.admin"]
}

module "iam" {
  source       = "../service-account"
  name         = var.name
  project_id   = var.project_id
  display_name = "Service Account for backend app"

  project_roles          = var.service_account.project_roles
  external_project_roles = var.service_account.external_project_roles

  bucket_roles = concat(var.service_account.bucket_roles, local.bucket_roles)
  depends_on = [
    google_storage_bucket.this
  ]
}
