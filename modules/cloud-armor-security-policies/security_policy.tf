locals {
  ### find all the preconfigured rule with no include or exclude expression
  pre_configured_rules_no_cond_expr = { for name, policy in var.pre_configured_rules : name => {
    expression = "evaluatePreconfiguredWaf('${policy["target_rule_set"]}', {'sensitivity': ${policy["sensitivity_level"]}})"
    } if length(policy["include_target_rule_ids"]) == 0 && length(policy["exclude_target_rule_ids"]) == 0
  }

  pre_configured_rules_include_expr = { for name, policy in var.pre_configured_rules : name => {
    expression = "evaluatePreconfiguredWaf('${policy["target_rule_set"]}', {'sensitivity': 0, 'opt_in_rule_ids': ['${replace(join(",", policy.include_target_rule_ids), ",", "','")}']})"
    } if length(policy["include_target_rule_ids"]) > 0 && length(policy["exclude_target_rule_ids"]) == 0
  }

  pre_configured_rules_exclude_expr = { for name, policy in var.pre_configured_rules : name => {
    expression = "evaluatePreconfiguredWaf('${policy["target_rule_set"]}', {'sensitivity': ${policy.sensitivity_level}, 'opt_out_rule_ids': ['${replace(join(",", policy.exclude_target_rule_ids), ",", "','")}']})"
    } if length(policy["include_target_rule_ids"]) == 0 && length(policy["exclude_target_rule_ids"]) > 0
  }
  ## Combine all the preconfigured rules
  pre_configured_rules_expr = merge(local.pre_configured_rules_no_cond_expr, local.pre_configured_rules_include_expr, local.pre_configured_rules_exclude_expr)


  ### generate whitelisted uris expression
  rate_limit_whiteslisted_uris_expr = join("&& ", [for uri in var.rate_limit_whiteslisted_uris : format("!request.path.matches('%s')", uri)])
}

resource "google_compute_security_policy" "this" {
  name     = var.name
  type     = var.type
  project  = var.project_id
  provider = google-beta

  # Preconfigures WAF Rules

  dynamic "rule" {
    for_each = var.pre_configured_rules
    content {
      action   = rule.value["action"] != null ? rule.value["action"] : "deny(403"
      priority = rule.value["priority"] != null ? rule.value["priority"] : rule.key + 1001
      preview  = var.audit_mode
      match {
        expr {
          expression = local.pre_configured_rules_expr[rule.key].expression
        }
      }

      # Optional preconfigured_waf_config Block if preconfigured_waf_config_exclusion is provided
      dynamic "preconfigured_waf_config" {
        for_each = rule.value.preconfigured_waf_config_exclusions == null ? [] : ["preconfigured_waf_config_exclusions"] #rule.value.preconfigured_waf_config_exclusions
        content {
          dynamic "exclusion" {
            for_each = rule.value.preconfigured_waf_config_exclusions
            content {
              target_rule_set = exclusion.value.target_rule_set
              target_rule_ids = exclusion.value.target_rule_ids
              dynamic "request_header" {
                for_each = exclusion.value.request_header == null ? {} : { for x in exclusion.value.request_header : "${x.operator}-${base64encode(coalesce(x.value, "test"))}" => x }
                content {
                  operator = request_header.value.operator
                  value    = request_header.value.operator == "EQUALS_ANY" ? null : request_header.value.value
                }
              }
              dynamic "request_cookie" {
                for_each = exclusion.value.request_cookie == null ? {} : { for x in exclusion.value.request_cookie : "${x.operator}-${base64encode(coalesce(x.value, "test"))}" => x }
                content {
                  operator = request_cookie.value.operator
                  value    = request_cookie.value.operator == "EQUALS_ANY" ? null : request_cookie.value.value
                }
              }
              dynamic "request_uri" {
                for_each = exclusion.value.request_uri == null ? {} : { for x in exclusion.value.request_uri : "${x.operator}-${base64encode(coalesce(x.value, "test"))}" => x }
                content {
                  operator = request_uri.value.operator
                  value    = request_uri.value.operator == "EQUALS_ANY" ? null : request_uri.value.value
                }
              }
              dynamic "request_query_param" {
                for_each = exclusion.value.request_query_param == null ? {} : { for x in exclusion.value.request_query_param : "${x.operator}-${base64encode(coalesce(x.value, "test"))}" => x }
                content {
                  operator = request_query_param.value.operator
                  value    = request_query_param.value.operator == "EQUALS_ANY" ? null : request_query_param.value.value
                }
              }
            }
          }
        }
      }
    }
  }

  # IP Whitelist enabled

  dynamic "rule" {
    for_each = var.whitelisted_ips
    content {
      action      = "allow"
      priority    = rule.key + 101 # TBD
      description = "IP Whitelist"
      preview     = var.audit_mode
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = [rule.value]
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.whitelist_region != null ? [""] : []
    content {
      action      = "allow"
      priority    = 6 # TBD
      description = "Region Whitelist"
      preview     = var.audit_mode
      match {
        expr {
          expression = "origin.region_code == '${var.whitelist_region}'"
        }
      }
    }
  }

  rule {
    action   = (var.whitelisted_ips != null || var.whitelist_region != null) ? "deny(403)" : "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }

  # Rate Limiting

  dynamic "rule" {
    for_each = var.rate_limit_number == null ? [] : [""]
    content {
      action      = "throttle"
      priority    = 10 # TDB
      description = "Rate Limiting"
      preview     = var.audit_mode

      match {
        dynamic "expr" {
          for_each = length(var.rate_limit_whiteslisted_uris) > 0 ? [""] : []
          content {
            expression = local.rate_limit_whiteslisted_uris_expr
          }
        }
      }

      rate_limit_options {
        conform_action = "allow"
        exceed_action  = "deny(429)"
        enforce_on_key = "IP"
        rate_limit_threshold {
          count        = var.rate_limit_number
          interval_sec = var.rate_limit_interval_number
        }
      }
    }
  }
}
