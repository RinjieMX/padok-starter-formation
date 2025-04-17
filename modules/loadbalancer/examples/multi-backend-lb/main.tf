# Short description of the use case in comments

locals {
  domain_name = "multibackendlb.padok.tech"
  project_id  = "gcp-library-terratest"
}

provider "google" {
  region = "europe-west3"
  zone   = "europe-west3-b"
}

resource "google_compute_managed_ssl_certificate" "this" {
  name    = "multibackendlb"
  project = local.project_id
  managed {
    domains = ["multibackendlb.${local.domain_name}", "www.multibackendlb.${local.domain_name}"]
  }
}

module "multi_backend_lb" {
  source = "../.."

  name       = "multibackendlb"
  project_id = local.project_id

  buckets_backends = {
    frontend = {
      hosts = ["multibackendlb.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = google_storage_bucket.this.name
    }
  }
  service_backends = {
    backend = {
      hosts = ["echo.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      groups = [google_compute_region_network_endpoint_group.backend.id]
    }
  }
  ssl_certificates    = [google_compute_managed_ssl_certificate.this.id]
  custom_cdn_policies = {}
}

resource "google_compute_region_network_endpoint_group" "backend" {
  name    = "multibackendlb"
  project = local.project_id

  region                = "europe-west3"
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = "echoserver"
  }
}

resource "google_storage_bucket" "this" {
  name     = "multibackendlb"
  project  = local.project_id
  location = "EU"
  #checkov:skip=CKV_GCP_62: Example, no connexion logging required
  #checkov:skip=CKV_GCP_78: Example, no versioning required

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}
