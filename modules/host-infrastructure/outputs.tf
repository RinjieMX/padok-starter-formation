output "network" {
  description = "Subnets created"
  value       = module.network
}

output "commands_to_connect" {
  description = "Commands to connect to bastion"
  value       = [for bastion in module.bastion : bastion.command_to_connect]
}

output "bastions" {
  description = "Bastions configuration"
  value       = local.bastions
}
