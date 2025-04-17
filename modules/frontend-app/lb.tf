# --- Provision load balancer --- #
module "loadbalancer" {
  source = "../loadbalancer"

  name       = replace(var.domain_name, ".", "-")
  project_id = var.project_id
  buckets_backends = {
    frontend = {
      hosts = [var.domain_name]
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
