resource "google_cloud_run_v2_service" "this" {
  provider     = google-beta
  name         = var.name
  location     = var.location
  launch_stage = "BETA"
  # deletion_protection defaults to "true". You may need to set "false" while initializing a new layer.
  #deletion_protection = false
  project             = var.project_id
  ingress             = var.network.ingress
  deletion_protection = var.cloud_run.deletion_protection

  template {
    service_account = module.service_account.this.email
    scaling {
      min_instance_count = var.cloud_run.min_instance_count
      max_instance_count = var.cloud_run.max_instance_count
    }
    vpc_access {
      connector = var.network.vpc_access_connector_self_link
      egress    = "PRIVATE_RANGES_ONLY"
    }
    max_instance_request_concurrency = var.cloud_run.max_instance_request_concurrency
    containers {
      name = "myfirstapp-1"
      ports {
        name           = var.cloud_run.ports["name"]
        container_port = var.cloud_run.ports["port"]
      }
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources {
        cpu_idle = false # CPU always allocated, it's more exenpsive but there is no cold start
        limits   = var.cloud_run.limits
      }
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      template[0].labels,
      client,
      client_version,
      # cf. https://github.com/hashicorp/terraform-provider-google/issues/13748
      launch_stage
    ]
  }
}

resource "google_cloud_run_service_iam_binding" "this" {
  project = var.project_id

  location = google_cloud_run_v2_service.this.location
  service  = google_cloud_run_v2_service.this.name

  role    = "roles/run.invoker"
  members = var.cloud_run.members
}
