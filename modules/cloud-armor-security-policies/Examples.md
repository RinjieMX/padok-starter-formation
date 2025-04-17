<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Here are a few example of the module usage](#here-are-a-few-example-of-the-module-usage)
  - [Use the module to enable Pre configured rules, in audit mode (without blocking)](#use-the-module-to-enable-pre-configured-rules-in-audit-mode-without-blocking)
  - [Use the module to enable region whitelisting](#use-the-module-to-enable-region-whitelisting)
  - [Use the module to enable IP whitelisting](#use-the-module-to-enable-ip-whitelisting)
  - [Use the module to enable rate limiting](#use-the-module-to-enable-rate-limiting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Here are a few example of the module usage

## Use the module to enable Pre configured rules, in audit mode (without blocking)

```tf
{
    project_id                           = "my-project-id"
    name                                 = "my-policy-name"
    type                                 = "CLOUD_ARMOR"
    audit_mode                           = true

    pre_configured_rules                 = {
        "sqli_sensitivity_level_4" = {
        action          = "deny(502)"
        priority        = 1
        target_rule_set = "sqli-v33-stable"

        sensitivity_level = 4
        description       = "sqli-v33-stable Sensitivity Level 4 and 2 preconfigured_waf_config_exclusions"
        }

        "xss-stable_level_2_with_exclude" = {
        action                  = "deny(502)"
        priority                = 2
        target_rule_set         = "xss-v33-stable"
        sensitivity_level       = 2
        exclude_target_rule_ids = ["owasp-crs-v030301-id941380-xss", "owasp-crs-v030301-id941280-xss"]
        }

        "php-stable_level_0_with_include" = {
        action                  = "deny(502)"
        priority                = 3
        description             = "PHP Sensitivity Level 0 with included rules"
        target_rule_set         = "php-v33-stable"
        include_target_rule_ids = ["owasp-crs-v030301-id933190-php", "owasp-crs-v030301-id933111-php"]
        }
    }
}
```

## Use the module to enable region whitelisting

```tf
{
    project_id                           = "my-project-id"
    name                                 = "my-policy-name"
    type                                 = "CLOUD_ARMOR"

    whitelist_region                     = "FR"
}
```

## Use the module to enable IP whitelisting

```tf
{
    project_id                           = "my-project-id"
    name                                 = "my-policy-name"
    type                                 = "CLOUD_ARMOR"

    ip_whitelisting_enabled              = true
    whitelisted_ips                      = ["195.135.98.90/32", "195.135.98.91/32"] # List of whitelisted ip ranges
}
```

## Use the module to enable rate limiting

```tf
{
    project_id                           = "my-project-id"
    name                                 = "my-policy-name"
    type                                 = "CLOUD_ARMOR"

    rate_limit_whiteslisted_uris         = ["/whitelisted_url"]
    rate_limit_number                    = 50
    rate_limit_interval_number           = 60
}
```
