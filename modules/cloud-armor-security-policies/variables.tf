variable "project_id" {
  type        = string
  description = "The project ID"
}

variable "name" {
  type        = string
  description = "Name of the policy"
}

variable "type" {
  type        = string
  description = "The type indicates the intended use of the security policy (CLOUD_ARMOR, CLOUD_ARMOR_EDGE, CLOUD_ARMOR_INTERNAL_SERVICE)"
}

variable "pre_configured_rules" {
  description = "Map of pre-configured rules with Sensitivity levels. preconfigured_waf_config_exclusion is obsolete and available for backward compatibility. Use preconfigured_waf_config_exclusions which allows multiple exclusions"
  type = map(object({
    action                  = optional(string, "deny(403)")
    priority                = optional(number, 1001)
    description             = optional(string)
    target_rule_set         = string
    sensitivity_level       = optional(number, 4)
    include_target_rule_ids = optional(list(string), [])
    exclude_target_rule_ids = optional(list(string), [])

    preconfigured_waf_config_exclusions = optional(map(object({
      target_rule_set = string
      target_rule_ids = optional(list(string), [])
      request_header = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_cookie = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_uri = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_query_param = optional(list(object({
        operator = string
        value    = optional(string)
      })))
    })), null)

  }))

  default = {}
}

variable "audit_mode" {
  type        = bool
  description = "Should Cloud Armor be deployed in preview mode or in blocking mode"
  default     = false
}


variable "whitelist_region" {
  description = "Origin Region Code that should be whitelisted by the WAF"
  type        = string
  default     = null
}

variable "whitelisted_ips" {
  description = "List of ip CIDR that should be whitelisted by the WAF"
  type        = list(string)
  default     = null
}

variable "rate_limit_whiteslisted_uris" {
  description = "List of URI whitelisted in the rate limit rule"
  type        = list(string)
  default     = []
}

variable "rate_limit_number" {
  type        = number
  default     = null
  description = "Number of request by IP in rate_limit_interval minutes before blocking."
}

variable "rate_limit_interval_number" {
  type        = number
  default     = 60
  description = "Interval over which the threshold is computed (in seconds)"
}
