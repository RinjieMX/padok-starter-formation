module "service_account" {
  source       = "git@github.com:padok-team/terraform-google-serviceaccount.git?ref=v2.0.1"
  name         = var.name
  project_id   = var.project_id
  display_name = "Service Account for ${var.name}"

  project_roles          = var.service_account.project_roles
  external_project_roles = var.service_account.external_project_roles
  bucket_roles           = var.service_account.bucket_roles
  secret_roles           = var.service_account.secret_roles
  service_account_roles  = var.service_account.service_account_roles
}
