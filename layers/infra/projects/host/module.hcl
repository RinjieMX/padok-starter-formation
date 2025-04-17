terraform {
  source = "git@github.com:terraform-google-modules/terraform-google-project-factory.git//.?ref=v13.0.0"
}

locals {
  # root locals
  root   = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  config = local.root.locals.config
}

inputs = {
  org_id          = local.root.locals.organization_id
  billing_account = local.root.locals.billing_account
  folder_id       = local.config.folder_id

  enable_shared_vpc_host_project = true
  random_project_id              = false

  activate_apis = [
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "iap.googleapis.com"
  ]
}
