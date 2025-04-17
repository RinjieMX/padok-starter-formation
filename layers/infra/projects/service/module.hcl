terraform {
  source = "git@github.com:terraform-google-modules/terraform-google-project-factory.git//.?ref=v13.1.0"
}

locals {
  # root locals
  root         = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  environment  = local.root.locals.environment
  config       = local.root.locals.config
  network_name = local.root.locals.config.network_name
  region       = local.root.locals.config.region
  root_dir     = local.root.locals.root_dir
}

dependency "project" {
  config_path = "${local.root_dir}/infra/projects/host/${local.config.host_project}"
}

dependency "network" {
  config_path = "${local.root_dir}/infra/host-infrastructure/main"
}

inputs = {
  org_id          = local.root.locals.organization_id
  billing_account = local.root.locals.billing_account

  folder_id = local.config.folder_id

  svpc_host_project_id = dependency.project.outputs.project_id

  create_project_sa = false
  shared_vpc_subnets = [
    dependency.network.outputs.network[local.network_name].subnets["${local.region}/${local.environment}"].id
  ]

  grant_services_security_admin_role = true
  random_project_id                  = false

  activate_apis = [
    "cloudasset.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "apigateway.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "pubsub.googleapis.com",
    "vpcaccess.googleapis.com",
    "dns.googleapis.com",
    "logging.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "monitoring.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "firebaseappcheck.googleapis.com",
    "firebaseappdistribution.googleapis.com",
    "firebasedynamiclinks.googleapis.com",
    "firebaseinstallations.googleapis.com",
    "firebaseremoteconfig.googleapis.com",
    "firebaserules.googleapis.com",
    "run.googleapis.com",
    "container.googleapis.com",
    "cloudscheduler.googleapis.com",
    "redis.googleapis.com"
    "osconfig.googleapis.com"
  ]
}
