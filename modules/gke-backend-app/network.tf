data "google_compute_subnetwork" "this" {
  count     = var.network.subnet_self_link != null ? 1 : 0
  self_link = var.network.subnet_self_link
}
