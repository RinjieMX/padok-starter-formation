output "artifact_registry_repository_id" {
  description = "ID of the created Artifact Registry repository"
  value       = google_artifact_registry_repository.docker.repository_id
}

output "artifact_registry_repository_url" {
  description = "URL of the Artifact Registry repository"
  value = "https://${
    google_artifact_registry_repository.docker.location
  }-docker.pkg.dev/${google_artifact_registry_repository.docker.project}/${google_artifact_registry_repository.docker.repository_id}"
}

output "workload_identity_pool_id" {
  description = "ID of the created Workload Identity Pool"
  value       = module.github_oidc.workload_identity_pool_id
}

output "workload_identity_pool_provider_id" {
  description = "ID of the Workload Identity Pool Provider"
  value       = module.github_oidc.workload_identity_pool_provider_id
}

output "service_account_github_email" {
  description = "Email of the service account used by Github"
  value       = module.github_oidc.service_account_github_email
}

output "service_account_github_name" {
  description = "Name of the service account used by Github"
  value       = module.github_oidc.service_account_github_name
}

output "github_principal_set" {
  description = "Principal Set for Workload Identity binding"
  value       = module.github_oidc.github_principal_set
}

output "cloudrun_admin_role_binding" {
  description = "Cloud Run Admin role binding for the Github Service Account"
  value       = google_project_iam_binding.iam_github_cloudrun.role
}

output "artifact_registry_writer_role_binding" {
  description = "Artifact Registry Writer role binding for the Github Service Account"
  value       = google_project_iam_binding.iam_github_artifactregistry.role
}