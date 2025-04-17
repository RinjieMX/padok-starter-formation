resource "google_dns_record_set" "this" {
  project = var.project_id
  name    = "${var.domain_name}."
  type    = "A"

  managed_zone = var.dns_zone_name

  rrdatas = [module.loadbalancer.ip_address]
}
