locals {
  username = "manong"
  root_dir    = get_parent_terragrunt_dir()
  environment = basename(get_original_terragrunt_dir())
  config_by_environment = {
    # Tooling projects
    infra = {
      project_id = "manong-starter-formation-infra"
      folder_id  = "1023736438293"
    },
    artifacts = {
      project_id = "manong-starter-formation-artifacts"
      folder_id  = "1023736438293"
    },
    # Host projects
    main = {
      project_id = "manong-starter-formation-host"
      folder_id  = "1023736438293"
    },
    # Service projects
    production = {
      host_project = "main"
      network_name = "manong-production"
      region       = "europe-west4"
      project_id   = "manong-starter-formation-production"
      folder_id    = "1023736438293"
    },
    staging = {
      host_project = "main"
      network_name = "manong-non-production"
      region       = "europe-west4"
      project_id   = "manong-starter-formation-staging"
      folder_id    = "1023736438293"
    },
  }
  config          = lookup(local.config_by_environment, local.environment, {})
  organization_id = "891835622849"
  billing_account = "0158A8-335199-B846CD"
}

inputs = {
  context = {
    # Organization ID where the project should be created, ⚠️ must be the same as host project
    organization_id = local.organization_id
    # Billing Account ID to attach to the project
    billing_account = local.billing_account
  }
}

# Remote backend configuration
remote_state {
  backend = "gcs"
  config = {
    bucket   = "manong-starter-formation-tfstates"
    project  = "padok-formation-initial"
    prefix   = "tfstate/${path_relative_to_include()}"
    location = "europe-west4"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "skip"
  }
}
terraform_version_constraint  = "~> 1.3"
terragrunt_version_constraint = "~> 0.43"
