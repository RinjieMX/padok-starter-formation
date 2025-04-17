terraform {
  source = "${get_path_to_repo_root()}/modules//cloud-run-infrastructure/."
}

locals {
  # root locals
  root             = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  config           = local.root.locals.config
  root_dir         = local.root.locals.root_dir
  environment      = local.root.locals.environment
  artifact_project = local.root.locals.config_by_environment["artifacts"].project_id
  host_project     = local.root.locals.config_by_environment["main"].project_id
}

inputs = {
  project_id           = local.config.project_id
  registry_project_ids = [local.artifact_project]
  host_project_id      = local.host_project
}
