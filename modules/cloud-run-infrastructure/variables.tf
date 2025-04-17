variable "registry_project_ids" {
  type        = list(string)
  description = "List of project IDs the Cloud Run Service will be able to pull images from"
  default     = []
}

variable "project_id" {
  description = "ID of the project hosting the Cloud Run app"
  type        = string
}

variable "host_project_id" {
  description = "ID of the host project hosting the network"
  type        = string
}
