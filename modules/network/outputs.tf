output "gcp_services_networking_connection" {
  value       = google_service_networking_connection.default
  description = "The networking connection used by GCP for services like Cloud SQL"
}

output "subnets" {
  value       = module.vpc.subnets
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets."
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network" {
  value       = module.vpc
  description = "The created network"
}

output "network_id" {
  value       = module.vpc.network_id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "subnets_names" {
  value       = module.vpc.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ids" {
  value       = module.vpc.subnets_ids
  description = "The IDs of the subnets being created"
}

output "vpc_access_connectors" {
  value       = google_vpc_access_connector.default
  description = "The VPC Access Connectors being created."
}
