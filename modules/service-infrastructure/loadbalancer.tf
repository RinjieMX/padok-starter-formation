data "google_project" "this" {
  project_id = var.context.project_id
}

# SSL Policy for L7 Load Balancer
# If you have clients that don't support TLS 1.2, use another profile
resource "google_compute_ssl_policy" "this" {
  name            = "modern"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
  project         = var.context.project_id
}

# Associate this IP to your IAP Load Balancer
# Using kubernetes.io/ingress.global-static-ip-name: "<IP_NAME>" annotation
resource "google_compute_global_address" "iap_lb_ip" {
  name    = "k8s-iap-lb-ip"
  project = var.context.project_id
}

# Associate this IP to your non-IAP Load Balancer
# Using kubernetes.io/ingress.global-static-ip-name: "<IP_NAME>" annotation
resource "google_compute_global_address" "non_iap_lb_ip" {
  name    = "k8s-non-iap-lb-ip"
  project = var.context.project_id
}

resource "google_project_service" "this" {
  project = var.context.project_id
  service = "iap.googleapis.com"
}

# Create IAP Client ID and Secret
resource "google_iap_client" "this" {
  display_name = "internal-iap-access"
  brand        = "projects/${data.google_project.this.number}/brands/${var.context.brand_id}"
}

resource "google_secret_manager_secret" "iap_id" {
  secret_id = "iap-client-id"
  project   = var.context.project_id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "iap_id" {
  secret      = google_secret_manager_secret.iap_id.id
  secret_data = google_iap_client.this.client_id
}

resource "google_secret_manager_secret" "iap_secret" {
  secret_id = "iap-client-secret"
  project   = var.context.project_id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "iap_secret" {
  secret      = google_secret_manager_secret.iap_secret.id
  secret_data = google_iap_client.this.secret
}
