output "dataform_repository" {
  value = google_dataform_repository.this
}

output "dataform_sa" {
  value = module.service_account.this
}
