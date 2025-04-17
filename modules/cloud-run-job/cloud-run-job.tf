# Based on GCP Module https://github.com/GoogleCloudPlatform/terraform-google-cloud-run/tree/v0.12.0/modules/job-exec
# we cannot use the provided module as their are no lifecycle policy on image, secrets, env...
resource "google_cloud_run_v2_job" "this" {
  name                = var.name
  project             = var.project_id
  location            = var.location
  launch_stage        = var.launch_stage
  labels              = var.labels
  depends_on          = [google_secret_manager_secret_iam_member.this]
  deletion_protection = var.deletion_protection

  template {
    labels      = var.labels
    parallelism = var.parallelism
    task_count  = var.task_count

    template {
      max_retries     = var.max_retries
      service_account = google_service_account.this.email
      timeout         = var.timeout

      containers {
        image   = var.image
        command = var.container_command
        args    = var.argument

        resources {
          limits = var.limits
        }

        dynamic "env" {
          for_each = var.env_secrets
          content {
            name = env.value.name
            value_source {
              secret_key_ref {
                secret  = reverse(split("/", env.value.secret))[0]
                version = env.value.version
              }
            }
          }
        }

        dynamic "volume_mounts" {
          for_each = var.volume_mounts
          content {
            name       = volume_mounts.value["name"]
            mount_path = volume_mounts.value["mount_path"]
          }
        }
      }

      dynamic "volumes" {
        for_each = var.volumes
        content {
          name = volumes.value["name"]
          cloud_sql_instance {
            instances = volumes.value.cloud_sql_instance["instances"]
          }
        }
      }

      dynamic "vpc_access" {
        for_each = var.vpc_access
        content {
          connector = vpc_access.value["connector_id"]
          egress    = vpc_access.value["egress"]
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Image set by the backend's deployment pipeline.
      template[0].template[0].containers[0].image,                 # To be removed if fully managed by terraform.
      template[0].template[0].containers[0].volume_mounts[0].name, # To be removed if fully managed by terraform.
      template[0].template[0].containers[0].env,                   # To be removed if fully managed by terraform.
      template[0].template[0].containers[0].command,               # To be removed if fully managed by terraform.
      template[0].template[0].volumes[0].name                      # To be removed if fully managed by terraform.
    ]
  }
}

resource "google_service_account" "this" {
  project    = var.project_id
  account_id = "sa-job-${var.name}"
}

resource "google_secret_manager_secret_iam_member" "this" {
  for_each = {
    for secret in var.env_secrets : secret.secret => secret
  }

  project   = var.project_id
  secret_id = each.value.secret
  role      = each.value.role
  member    = "serviceAccount:${google_service_account.this.email}"
}

# This binding allows for ci/cd service account to deploy or run the cloud run job.
resource "google_service_account_iam_binding" "this" {
  count              = var.cicd_service_account_list == [] ? 0 : 1
  service_account_id = google_service_account.this.name
  role               = "roles/iam.serviceAccountUser"

  members = var.cicd_service_account_list
}

resource "google_cloud_run_v2_job_iam_binding" "deploy" {
  count    = var.cicd_service_account_list == [] ? 0 : 1
  name     = google_cloud_run_v2_job.this.name
  location = var.location
  project  = var.project_id
  role     = "roles/run.developer"

  members = var.cicd_service_account_list
}

resource "google_cloud_run_v2_job_iam_binding" "invoke" {
  count    = var.cicd_service_account_list == [] ? 0 : 1
  name     = google_cloud_run_v2_job.this.name
  location = var.location
  project  = var.project_id
  role     = "roles/run.invoker"

  members = var.cicd_service_account_list
}
