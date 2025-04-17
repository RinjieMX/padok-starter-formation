output "workload_identity_pool_id" {
  description = "ID of the created Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github.workload_identity_pool_id
}

output "workload_identity_pool_provider_id" {
  description = "ID of the Workload Identity Pool Provider"
  value       = google_iam_workload_identity_pool_provider.github.workload_identity_pool_provider_id
}

output "service_account_github_email" {
  description = "Email of the service account used by Github"
  value       = try(google_service_account.github[0].email, "")
}

output "service_account_github_name" {
  description = "Name of the service account used by Github"
  value       = try(google_service_account.github[0].name, "")
}

output "github_principal_set" {
  description = "Principal Set for Workload Identity binding"
  value       = local.github_principal_set
}
