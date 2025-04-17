variable "name" {
  description = "Name of the service account"
  type        = string
}

variable "project_id" {
  description = "The project to deploy the ressources to."
  type        = string
}

variable "display_name" {
  description = "Name displayed in the IAM page"
  type        = string
}

variable "project_roles" {
  description = "Roles that will be set at project scope on project_id provided variable"
  type        = list(string)
  default     = []
}

variable "external_project_roles" {
  description = "Roles that will be set at project scope on projects passed like {PROJECT_ID}=>{ROLE}"
  type        = list(string)
  default     = []
}

variable "secret_roles" {
  description = "Roles that will be set at secret scope on secrets passed like {SECRET_ID}=>{ROLE}"
  type        = list(string)
  default     = []
}

variable "service_account_roles" {
  description = "Roles that will be set at service_account scope on service_account passed like {SERVICE_ACCOUNT_ID}=>{ROLE}"
  type        = list(string)
  default     = []
}

variable "bucket_roles" {
  description = "Roles that will be set at bucket scope on buckets passed like {BUCKET}=>{ROLE}"
  type        = list(string)
  default     = []
}

variable "members" {
  description = "Defines members that can use this service_account using a role passed like {MEMBER}=>{ROLE}"
  type        = list(string)
  default     = []
}
