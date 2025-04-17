locals {
  location_map = {
    "europe" = "EU"
    "us"     = "US"
  }
  bucket_location = split("-", data.google_compute_subnetwork.this[0].region)[0]
}

resource "google_storage_bucket" "this" {
  #checkov:skip=CKV_GCP_62:Access logging not required for this bucket
  #checkov:skip=CKV_GCP_78:Versioning managed by variables
  for_each = { for k, x in var.buckets : k => x }

  project  = var.project_id
  name     = each.value.name
  location = local.location_map[local.bucket_location]

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = each.value.versioning
  }
}
