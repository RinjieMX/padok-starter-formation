# Official Google module for PostgreSQL: https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/postgresql
data "google_compute_zones" "this" {
  project = var.project_id
  region  = var.region
}
