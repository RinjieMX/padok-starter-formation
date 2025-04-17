variable "service_account" {
  description = "Service account used by the Cloud Run app"
  type = object({
    project_roles          = list(string) # list of {ROLE}
    external_project_roles = list(string) # using format {PROJECT_ID}=>{ROLE}
    bucket_roles           = list(string) # using format {BUCKET}=>{ROLE}
    secret_roles           = list(string) # using format {SECRET_ID}=>{ROLE}
    service_account_roles  = list(string) # using format {SERVICE_ACCOUNT_ID}=>{ROLE}
  })
  default = {
    project_roles          = []
    external_project_roles = []
    bucket_roles           = []
    secret_roles           = []
    service_account_roles  = []
  }
}

variable "project_id" {
  description = "ID of the project hosting the dataform repository"
  type        = string
}

variable "name" {
  description = "Name of the resources"
  type        = string
  default     = "dataform"
}

variable "git_ssh_url" {
  description = "SSH URL of the git repository to use with dataform"
  type        = string
}

variable "git_branch" {
  description = "Branch of the git repository to use with dataform"
  type        = string
}

variable "region" {
  description = "Region of the resources"
  type        = string
  default     = "europe-west3"
}

variable "environment" {
  description = "Environment for the dataform repository"
  type        = string
}
