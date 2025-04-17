output "instance_name" {
  description = "The instance name for the master instance."
  value       = module.mysql_db.instance_name
}

output "instance_connection_name" {
  description = "The connection name of the master instance to be used in connection strings."
  value       = module.mysql_db.instance_connection_name
}

output "read_replica_instance_names" {
  description = "The instance names for the read replica instances."
  value       = module.mysql_db.read_replica_instance_names
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance."
  value       = var.public ? module.mysql_db.public_ip_address : ""
}

output "private_ip_address" {
  description = "The first private IPv4 address assigned for the master instance."
  value       = module.mysql_db.private_ip_address
}

output "users" {
  description = "List of maps of users and passwords."
  value = [for r in module.mysql_db.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "key_id" {
  description = "The id of encryption key."
  value       = var.encryption_key_id == null ? google_kms_crypto_key.this[0].id : var.encryption_key_id
}

output "secrets" {
  description = "The secrets created for the users."
  value       = google_secret_manager_secret.password
  sensitive   = true
}
