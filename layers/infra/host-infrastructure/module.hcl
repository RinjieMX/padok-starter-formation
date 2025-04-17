terraform {
  source = "${get_path_to_repo_root()}/modules//host-infrastructure"
}

locals {
  # root locals
  root   = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  config = local.root.locals.config
}

inputs = {
  context = {
    project_name = local.config.project_id
  }
}
