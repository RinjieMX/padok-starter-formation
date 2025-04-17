provider "google" {
  region = "europe-west3"
  zone   = "europe-west3-b"
}

locals {
  domain_name = "simplestaticfrontend.padok.tech"
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

resource "google_dns_record_set" "this" {
  managed_zone = "padok-tech"
  project      = local.project_id
  name         = "${local.domain_name}."
  type         = "A"
  rrdatas      = [module.loadbalancer.ip_address]
}

# --- Provision load balancer --- #
module "loadbalancer" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  source = "../../../loadbalancer"

  name       = replace(local.domain_name, ".", "-")
  project_id = local.project_id
  buckets_backends = {
    frontend = {
      hosts = [local.domain_name]
      path_rules = [
        {
          paths = ["/*"]
        }
      ]
      bucket_name = module.frontend.bucket.name
    }
  }
  service_backends = {}
  ssl_certificates = [google_compute_managed_ssl_certificate.this.id]
}

# --- Deploy frontend --- #
module "frontend" {
  source     = "../.."
  name       = "simplestaticfrontend"
  location   = "europe-west3"
  project_id = local.project_id
}
