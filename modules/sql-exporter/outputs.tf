output "bucket_name" {
  description = "The name of the bucket in which export files will be kept"
  value       = google_storage_bucket.this.name
}

output "pubsub_topic" {
  description = "The pubsub topic id"
  value       = module.pubsub.id
}
