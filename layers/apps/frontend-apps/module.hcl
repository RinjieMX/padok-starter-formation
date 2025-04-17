terraform {
  source = "${get_path_to_repo_root()}/modules//frontend-app/."
}

locals {
  # root locals
  root        = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  config      = local.root.locals.config
  root_dir    = local.root.locals.root_dir
  environment = local.root.locals.environment
}

inputs = {
  project_id = local.config.project_id
  region     = local.config.region
}
