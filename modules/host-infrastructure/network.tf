locals {
  bastions = {
    for name, network in var.context.networks : name => network.bastion
  }
  bastion_subnets = {
    for name, bastion in local.bastions : name =>
    {
      "${name}-bastion" = {
        name             = "${name}-bastion"
        region           = bastion.region
        primary_cidr     = bastion.subnet
        serverless_cidr  = ""
        secondary_ranges = {}
      }
    }
  }
}

module "network" {
  source   = "../network"
  for_each = var.context.networks

  project_id = var.context.project_name

  name             = each.value.name
  subnets          = merge(each.value.subnets, local.bastion_subnets[each.key])
  gcp_peering_cidr = each.value.gcp_peering_cidr
}
