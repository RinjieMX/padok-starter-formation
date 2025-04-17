# example outputs.tf using the moodule's outputs

output "gcp_services_networking_connection" {
  value = module.gke.gcp_services_networking_connection
}

output "subnets" {
  value = module.gke.subnets
}

output "network_name" {
  value = module.gke.network_name
}

output "network" {
  value = module.gke.network
}

output "network_id" {
  value = module.gke.network_id
}

output "network_self_link" {
  value = module.gke.network_self_link
}

output "subnets_names" {
  value = module.gke.subnets_names
}

output "subnets_ids" {
  value = module.gke.subnets_ids
}

output "vpc_access_connectors" {
  value = module.gke.vpc_access_connectors
}
