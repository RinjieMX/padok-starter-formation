variable "project_id" {
  description = "The ID of the project where to deploy the workload identity pool."
  type        = string
}

variable "github_orga_name" {
  description = "The name of the GitHub organization."
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository."
  type        = string
}

variable "workload_identity_pool_id" {
  description = "ID of the created Workload Identity Pool, default is 'github'"
  type        = string
  default     = ""
}

variable "workload_identity_pool_provider_id" {
  description = "ID of the Workload Identity Pool Provider, default is 'var.github_orga_name-var.github_repo_name'"
  type        = string
  default     = ""
}

variable "create_service_account" {
  description = "Create a service account for Github, default is false"
  type        = bool
  default     = false
}

variable "service_account_github_name" {
  description = "Name of the service account used by Github"
  type        = string
  default     = "github"
}

variable "attribute_condition" {
  description = <<EOF
  Attribute condition that must be matched for the binding to work (type can be: repository, repository_owner, branch, custom).
  If not defined, the default condition is repository=='var.github_orga_name/var.github_repo_name'
EOF
  type = object({
    type  = optional(string)
    value = optional(string)
  })
  default = {}
}
