# This example creates a SSL certificate and attach it to a new load balancer

locals {
  domain_name = "lbwithcustomcertificate.padok.tech"
  project_id  = "gcp-library-terratest"
}

provider "google" {
  region = "europe-west3"
  zone   = "europe-west3-b"
}

resource "google_compute_managed_ssl_certificate" "this" {
  name    = "lbwithcustomcertificate"
  project = local.project_id
  managed {
    domains = ["lbwithcustomcertificate.${local.domain_name}", "www.lbwithcustomcertificate.${local.domain_name}"]
  }
}

module "my_lb" {
  source = "../.."

  name       = "lbwithcustomcertificate"
  project_id = local.project_id

  buckets_backends = {
    frontend = {
      hosts = ["lbwithcustomcertificate.${local.domain_name}", "www.lbwithcustomcertificate.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = google_storage_bucket.this.name
    }
  }
  service_backends    = {}
  ssl_certificates    = [google_compute_managed_ssl_certificate.this.id]
  custom_cdn_policies = {}
}

resource "google_storage_bucket" "this" {
  name     = "lbwithcustomcertificate"
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
