variable "context" {
  description = "Contexte du projet, contenant toutes les informations nécessaires"
  type = object({
    project_id       = string
    gcp_repo_name    = string
    region           = string
    github_repo_name = string
    github_orga_name = string
    conditions = optional(object({
      type  = optional(string)
      value = optional(string)
    }))
  })
}