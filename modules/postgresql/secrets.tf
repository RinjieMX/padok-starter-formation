# Passwords
resource "random_password" "password" {
  for_each         = toset(var.users)
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_secret_manager_secret" "password" {
  for_each = { for u in var.users : u => u if var.create_secrets }

  project = var.project_id

  secret_id = "DATABASE_${upper(var.name)}_${upper(each.key)}_PASSWORD"

  labels = var.labels

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "password" {
  for_each = { for u in var.users : u => u if var.create_secrets }

  secret      = google_secret_manager_secret.password[each.key].id
  secret_data = random_password.password[each.key].result
}
