output "job_name" {
  value       = google_cloud_run_v2_job.this.name
  description = "Name of the Cloud Run Job."
}
