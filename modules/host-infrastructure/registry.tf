module "registry" {
  count  = lookup(var.context, "registry", null) != null ? 1 : 0
  source = "../artifacts-oidc-github"
  context = {
    project_id       = var.context.project_name
    region           = var.context.registry.region
    gcp_repo_name    = var.context.registry.repo_name
    github_orga_name = var.context.registry.github_orga_name
    github_repo_name = var.context.registry.github_repo_name
    conditions = lookup(var.context.registry, "conditions", null) != null ? length(var.context.registry.conditions) > 0 ? {
      for condition_key, condition_value in var.context.registry.conditions : condition_key => {
        type  = condition_value.type
        value = condition_value.value
      }
    } : null : null
  }
}
