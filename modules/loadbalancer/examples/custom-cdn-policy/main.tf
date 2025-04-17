provider "google" {
  region = "europe-west3"
  zone   = "europe-west3-b"
}

locals {
  domain_name = "customcdnpolicy.padok.tech"
  project_id  = "gcp-library-terratest"
}

# --- Generate Certificate --- #
resource "google_compute_managed_ssl_certificate" "this" {
  project = local.project_id

  name = replace(local.domain_name, ".", "-")
  managed {
    domains = [local.domain_name]
  }
}

module "custom_cdn_policy_lb" {
  source = "../.."

  name       = "customcdnpolicy"
  project_id = local.project_id

  buckets_backends = {
    frontend = {
      hosts = ["frontend.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = google_storage_bucket.this.name
      cdn_policy  = "custom_react"
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
  ssl_certificates = [google_compute_managed_ssl_certificate.this.id]
  custom_cdn_policies = {
    custom_react = {
      cache_mode       = "USE_ORIGIN_HEADERS"
      negative_caching = true
      negative_caching_policy = {
        "404" = {
          code = "404"
          ttl  = "1"
        },
        "302" = {
          code = "302"
          ttl  = "1"
        },
      }
    },
  }
}

resource "google_compute_region_network_endpoint_group" "backend" {
  name                  = "customcdnpolicy"
  project               = local.project_id
  region                = "europe-west1"
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = "echoserver"
  }
}

resource "google_storage_bucket" "this" {
  name     = "customcdnpolicy"
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
