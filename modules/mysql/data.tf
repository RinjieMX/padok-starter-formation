# Official Google module for MySQL: https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/mysql
data "google_compute_zones" "this" {
  project = var.project_id
  region  = var.region
}
