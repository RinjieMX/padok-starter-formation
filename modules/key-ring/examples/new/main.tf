resource "random_id" "kms_key" {
  byte_length = 3
  prefix      = "kms-test-key-"
}

module "key_ring" {
  source = "../.."

  project_id        = "gcp-library-terratest"
  key_ring_location = "europe-west9"
  key_ring_name     = random_id.kms_key.hex
}

output "key_ring_id" {
  value = module.key_ring.key_ring.id
}
