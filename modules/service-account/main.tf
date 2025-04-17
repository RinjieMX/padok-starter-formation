resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = var.name
  description  = "Managed By Terraform"
  display_name = var.display_name
}

resource "google_project_iam_member" "this" {
  for_each = toset(var.project_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.this.email}"
}

resource "google_project_iam_member" "external" {
  for_each = toset(var.external_project_roles)
  project  = element(split("=>", each.value), 0, )
  role     = element(split("=>", each.value), 1, )
  member   = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_bucket_iam_member" "this" {
  for_each = toset(var.bucket_roles)
  bucket   = element(split("=>", each.value), 0, )
  role     = element(split("=>", each.value), 1, )
  member   = "serviceAccount:${google_service_account.this.email}"
}

resource "google_secret_manager_secret_iam_member" "this" {
  for_each  = toset(var.secret_roles)
  secret_id = element(split("=>", each.value), 0, )
  role      = element(split("=>", each.value), 1, )
  member    = "serviceAccount:${google_service_account.this.email}"
}

resource "google_service_account_iam_member" "this" {
  for_each           = toset(var.service_account_roles)
  service_account_id = element(split("=>", each.value), 0, ) == "this" ? google_service_account.this.name : element(split("=>", each.value.role), 0, )
  role               = element(split("=>", each.value), 1, )
  member             = "serviceAccount:${google_service_account.this.email}"
}

resource "google_service_account_iam_member" "members" {
  for_each           = toset(var.members)
  service_account_id = google_service_account.this.name
  role               = element(split("=>", each.value), 1, )
  member             = element(split("=>", each.value), 0, )
}
