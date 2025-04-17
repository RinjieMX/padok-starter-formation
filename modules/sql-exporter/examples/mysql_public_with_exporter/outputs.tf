output "instance_name" {
  value       = module.my-public-mysql-db-with-backup.instance_name
  description = "The instance name for the master instance"
}

output "instance_connection_name" {
  value       = module.my-public-mysql-db-with-backup.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "read_replica_instance_names" {
  value       = module.my-public-mysql-db-with-backup.read_replica_instance_names
  description = "The instance names for the read replica instances"
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = module.my-public-mysql-db-with-backup.private_ip_address
}

output "users" {
  description = "List of maps of additional users and passwords"
  value = [for r in module.my-public-mysql-db-with-backup.users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "secrets" {
  description = "The secrets created for the users."
  value       = module.my-public-mysql-db-with-backup.secrets
  sensitive   = true
}
