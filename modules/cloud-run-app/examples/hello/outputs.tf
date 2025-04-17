output "cloud_run_url" {
  description = "Cloud Run URL"
  value       = module.cloud_run.cloud_run_url
}

output "gcloud_run_deploy_command" {
  description = "Cloud Run Deploy Command"
  value       = module.cloud_run.gcloud_run_deploy_command
}
