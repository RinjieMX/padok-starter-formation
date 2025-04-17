module "bastion" {
  source   = "../bastion"
  for_each = local.bastions

  project_id = var.context.project_name

  name                      = "${each.key}-bastion"
  network_self_link         = module.network[each.key].network_self_link
  subnet_self_link          = module.network[each.key].subnets["${each.value.region}/${each.key}-bastion"].self_link
  region                    = each.value.region
  members                   = each.value.members
  enable_automated_patching = true
}
