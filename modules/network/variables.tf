variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created."
}

variable "name" {
  type        = string
  description = "The name of the network being created."
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')."
}

variable "subnets" {
  type = map(object({
    name            = string
    region          = string
    primary_cidr    = string
    serverless_cidr = string
    purpose         = optional(string, null)
    connector_specs = optional(object({
      machine_type   = optional(string, null)
      min_throughput = optional(number, null)
      min_instances  = optional(number, null)
      max_throughput = optional(number, null)
      max_instances  = optional(number, null)
    }), {})
    secondary_ranges = map(object({
      name = string
      cidr = string
    }))
  }))
  description = "The list of subnets beeing created."
}

variable "nats" {
  type = map(object({
    mode      = optional(string, "ENDPOINT_INDEPENDANT_MAPPING")
    min_ports = optional(number, 64)
    max_ports = optional(number, null)
  }))
  default     = {}
  description = "The custom configuration for NAT gateways. The map key must be the nat region and there must be a subnet in that region. Possible values for mode are `ENDPOINT_INDEPENDANT_MAPPING`, `DYNAMIC_PORT_ALLOCATION` or `NONE`."

  validation {
    condition     = alltrue([for nat in var.nats : contains(["DYNAMIC_PORT_ALLOCATION", "ENDPOINT_INDEPENDANT_MAPPING", "NONE"], nat.mode)])
    error_message = "Nat mode must either be ENDPOINT_INDEPENDANT_MAPPING, DYNAMIC_PORT_ALLOCATION or NONE"
  }
}

variable "gcp_peering_cidr" {
  type        = string
  description = "The CIDR to reserve for GCP service in this VPC."
}
