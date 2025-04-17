locals {
  location_map = {
    "europe" = "EU"
    "us"     = "US"
  }
  bucket_location = split("-", var.location)[0]
}

resource "google_storage_bucket" "this" {
  for_each = var.buckets

  #checkov:skip=CKV_GCP_62:not relevant in this context

  project  = var.project_id
  name     = each.value.name
  location = local.location_map[local.bucket_location]
  versioning {
    enabled = true
  }

  uniform_bucket_level_access = "true"
  public_access_prevention    = "enforced"
}
