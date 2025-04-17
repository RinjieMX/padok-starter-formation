output "gcloud_run_deploy_command" {
  description = "Command to deploy the cloudrun"
  value       = "gcloud run deploy --project ${var.project_id} --region ${var.location} ${google_cloud_run_v2_service.this.name}"
}

output "cloud_run_url" {
  description = "URL of the cloudrun entrypoint"
  value       = google_cloud_run_v2_service.this.uri
}
