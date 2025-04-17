
resource "google_cloud_scheduler_job" "this" {
  count            = var.type == "schedule" ? 1 : 0
  provider         = google-beta
  name             = "job-${var.name}"
  paused           = var.scheduler.paused
  description      = var.scheduler.description
  schedule         = var.scheduler.schedule
  attempt_deadline = var.scheduler.attempt_deadline
  region           = var.scheduler.region
  project          = var.project_id

  retry_config {
    retry_count = var.scheduler.retry_count
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.this.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.this.name}:run"

    oauth_token {
      service_account_email = google_service_account.scheduler[0].email
    }
  }

  depends_on = [google_cloud_run_v2_job.this, google_cloud_run_v2_job_iam_member.scheduler]
}

resource "google_service_account" "scheduler" {
  count      = var.type == "schedule" ? 1 : 0
  account_id = "sa-scheduler-${var.name}"
  project    = var.project_id
}

resource "google_cloud_run_v2_job_iam_member" "scheduler" {
  count    = var.type == "schedule" ? 1 : 0
  member   = "serviceAccount:${google_service_account.scheduler[0].email}"
  name     = google_cloud_run_v2_job.this.name
  location = google_cloud_run_v2_job.this.location
  project  = google_cloud_run_v2_job.this.project
  role     = "roles/run.invoker"
}
