# --- Generate Certificate --- #
resource "google_compute_managed_ssl_certificate" "this" {
  project = var.project_id

  name = replace(var.domain_name, ".", "-")
  managed {
    domains = [var.domain_name]
  }
}
