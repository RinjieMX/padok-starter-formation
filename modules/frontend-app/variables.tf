variable "project_id" {
  type        = string
  description = "The project ID"
}

variable "region" {
  type        = string
  description = "GCP region in which the bucket will be created"
}

variable "name" {
  type        = string
  description = "Name of the frontend bucket"
}

variable "domain_name" {
  type        = string
  description = "Domain name of the frontend"
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the gcp managed dns zone in which to create the dns record"
}
