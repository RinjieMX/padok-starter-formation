variable "name" {
  description = "Name of the Cloud Run app"
  type        = string
}

variable "project_id" {
  description = "ID of the project hosting the Cloud Run app"
  type        = string
}

variable "location" {
  description = "GCP location, example: europe-west1"
  type        = string
}

variable "network" {
  description = "Object containing information about the network hosting the Cloud Run app"
  type = object({
    resource_link                  = string
    gcp_peering_connection         = string
    vpc_access_connector_self_link = string
    ingress                        = string
  })
  default = {
    resource_link                  = null
    gcp_peering_connection         = null
    vpc_access_connector_self_link = null
    ingress                        = "INGRESS_TRAFFIC_ALL" # this can be INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER or INGRESS_TRAFFIC_INTERNAL_ONLY
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

variable "buckets" {
  description = "List of the buckets managed by the Terraform code"
  type = map(object({
    name = string
  }))
  default = {}
}


variable "cloud_run" {
  description = "Object describing the Cloud Run app itself"
  type = object({
    generate_revision_name = optional(bool, true)
    service_labels         = optional(map(string), {})
    service_annotations    = optional(map(string), {})
    command                = optional(list(string), [])
    args                   = optional(list(string), [])
    ports = optional(object({
      name = string
      port = number
      }), {
      name = "http1"
      port = 8080
    })
    limits                           = optional(map(string), {})
    requests                         = optional(map(string), {})
    container_concurrency            = optional(number, null)
    timeout_seconds                  = optional(number, 120)
    template_labels                  = optional(map(string), {})
    template_annotations             = optional(map(string), {})
    registry_project_ids             = optional(list(string), [])
    members                          = optional(list(string), ["allUsers"])
    min_instance_count               = optional(number, 1)
    max_instance_count               = optional(number, 50)
    env                              = optional(map(string), {})
    max_instance_request_concurrency = optional(number)
    deletion_protection              = optional(bool, true)
  })
}
