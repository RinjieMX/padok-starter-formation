output "key_ring" {
  description = "The key ring resource"
  value       = var.existing_key_ring_name == "" ? google_kms_key_ring.this[0] : data.google_kms_key_ring.this[0]
}
