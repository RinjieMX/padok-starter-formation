resource "google_storage_bucket_iam_member" "exporter" {
  for_each = var.sql_exporter == null ? toset([]) : toset(["1"])
  bucket   = var.sql_exporter.bucket_name
  role     = "roles/storage.admin"
  member   = "serviceAccount:${module.postgresql_db.instance_service_account_email_address}"
}

resource "google_cloud_scheduler_job" "exporter" {
  for_each = var.sql_exporter == null ? {} : {
    for key, value in var.databases : key => value
    if value.export_backup
  }

  name        = "${each.key}-exporter"
  project     = var.project_id
  region      = var.region
  description = "exporter"
  schedule    = each.value.export_schedule
  time_zone   = var.sql_exporter.timezone

  pubsub_target {
    topic_name = var.sql_exporter.pubsub_topic
    data       = base64encode("{\"Db\": \"${each.key}\", \"Instance\": \"${module.postgresql_db.instance_name}\", \"Project\": \"${var.project_id}\", \"Gs\": \"gs://${var.sql_exporter.bucket_name}\"}")
  }
}
