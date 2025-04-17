# Patch bastion packages weekly
resource "google_os_config_patch_deployment" "patch" {
  count = var.enable_automated_patching ? 1 : 0

  project             = var.project_id
  patch_deployment_id = var.name

  instance_filter {
    instance_name_prefixes = [var.name]
  }

  patch_config {
    reboot_config = "DEFAULT"
    apt {
      type = "DIST"
    }
  }

  duration = "300s"

  recurring_schedule {
    time_zone {
      id = "Europe/Paris"
    }

    time_of_day {
      hours   = 0
      minutes = 0
    }

    weekly {
      day_of_week = "SUNDAY"
    }
  }
}
