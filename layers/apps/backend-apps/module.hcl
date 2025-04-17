terraform {
  source = "${get_path_to_repo_root()}/modules//cloud-run-app/."
}

locals {
  # root locals
  root        = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  config      = local.root.locals.config
  root_dir    = local.root.locals.root_dir
  environment = local.root.locals.environment
}

dependency "network" {
  config_path = "${local.root_dir}/infra/host-infrastructure/${local.config.host_project}"
}

inputs = {
  project_id = local.config.project_id
  network = {
    subnet_self_link               = dependency.network.outputs.network[local.config.network_name].subnets["${local.config.region}/${local.environment}"].self_link
    gcp_peering_connection         = dependency.network.outputs.network[local.config.network_name].gcp_services_networking_connection[0].reserved_peering_ranges[0]
    vpc_access_connector_self_link = dependency.network.outputs.network[local.config.network_name].vpc_access_connectors[keys(dependency.network.outputs.network[local.config.network_name].vpc_access_connectors)[0]].self_link

  }
  cloud_run = {}
}
