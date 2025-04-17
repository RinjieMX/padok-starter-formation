terraform {
  source = "git@github.com:terraform-google-modules/terraform-google-project-factory.git//.?ref=v13.1.0"
}

locals {
  # root locals
  root   = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals
  config = local.root.config
}

inputs = {
  org_id          = local.root.organization_id
  billing_account = local.root.billing_account

  folder_id         = local.config.folder_id
  random_project_id = false

  activate_apis = [
    "storage-api.googleapis.com",
  ]
}
