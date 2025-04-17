# example outputs.tf using the moodule's outputs

output "gcp_services_networking_connection" {
  value = module.basic.gcp_services_networking_connection
}

output "subnets" {
  value = module.basic.subnets
}

output "network_name" {
  value = module.basic.network_name
}

output "network" {
  value = module.basic.network
}

output "network_id" {
  value = module.basic.network_id
}

output "network_self_link" {
  value = module.basic.network_self_link
}

output "subnets_names" {
  value = module.basic.subnets_names
}

output "subnets_ids" {
  value = module.basic.subnets_ids
}

output "vpc_access_connectors" {
  value = module.basic.vpc_access_connectors
}
