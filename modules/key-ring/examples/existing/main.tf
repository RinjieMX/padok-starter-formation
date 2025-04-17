module "key_ring" {
  source = "../.."

  project_id             = "gcp-library-terratest"
  key_ring_location      = "europe-west9"
  existing_key_ring_name = "kms-test-key-d629e0"
}

output "key_ring_id" {
  value = module.key_ring.key_ring.id
}
