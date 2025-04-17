variable "name" {
  description = "Name of the Cloud Run app"
  type        = string
}

variable "project_id" {
  description = "ID of the project hosting the Cloud Run app"
  type        = string
}

variable "network" {
  description = "Object containing information about the network hosting the Cloud Run app"
  type = object({
    subnet_self_link       = string
    gcp_peering_connection = string
  })
  default = {
    subnet_self_link       = null
    gcp_peering_connection = null
  }
}

variable "databases" {
  description = "List of the databases managed by the Terraform code"
  type = map(object({
    tier              = string
    availability_type = string
    engine_version    = string
    public            = bool
    backup_region     = string
  }))
  default = {}
}

variable "redis" {
  description = "List of the Redis instances managed by the Terraform code"
  type = map(object({
    tier    = string
    memory  = number
    version = string
  }))
  default = {}
}

variable "service_account" {
  description = "Service account used by the Cloud Run app"
  type = object({
    project_roles          = list(string)
    external_project_roles = list(string)
    bucket_roles           = list(string)
  })
  default = {
    project_roles          = []
    external_project_roles = []
    bucket_roles           = []
  }
}

variable "buckets" {
  description = "List of the buckets managed by the Terraform code"
  type = map(object({
    name       = string
    versioning = bool
  }))
  default = {}
}
