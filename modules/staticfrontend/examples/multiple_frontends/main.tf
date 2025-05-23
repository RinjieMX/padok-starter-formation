provider "google" {
  region = "europe-west3"
  zone   = "europe-west3-b"
}

locals {
  domain_name     = "padok.tech"
  subdomain_names = ["frontend1", "frontend2"]
  hosts           = [for sub in local.subdomain_names : "${sub}.${local.domain_name}"]
  certificates = [
    google_compute_managed_ssl_certificate.this["frontend1.padok.tech"].id,
    google_compute_managed_ssl_certificate.this["frontend2.padok.tech"].id
  ]
  project_id = "gcp-library-terratest"
}

resource "google_dns_record_set" "this" {
  managed_zone = replace(local.domain_name, ".", "-")
  for_each     = toset(local.hosts)
  project      = local.project_id
  name         = "${each.value}."
  type         = "A"
  rrdatas      = [module.loadbalancer.ip_address]
}

# --- Generate Certificates --- #
resource "google_compute_managed_ssl_certificate" "this" {
  for_each = toset(local.hosts)
  project  = local.project_id

  name = replace(each.value, ".", "-")
  managed {
    domains = [each.value]
  }
}

# --- Provision load balancer --- #
module "loadbalancer" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  source = "../../../loadbalancer"

  name       = replace(local.domain_name, ".", "-")
  project_id = local.project_id
  buckets_backends = {
    frontend-1 = {
      hosts = ["frontend1.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = module.frontend1.bucket.name
    }
    frontend-2 = {
      hosts = ["frontend2.${local.domain_name}"]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = module.frontend2.bucket.name
    }
  }
  service_backends = {}
  ssl_certificates = local.certificates
}

# --- Deploy frontends --- #
module "frontend1" {
  source     = "../.."
  name       = "frontendpadok1"
  location   = "europe-west1"
  project_id = local.project_id
}

module "frontend2" {
  source     = "../.."
  name       = "frontendpadok2"
  location   = "europe-west1"
  project_id = local.project_id
}
