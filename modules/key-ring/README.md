# Google keyring Terraform module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [User Stories for this module](#user-stories-for-this-module)
- [Usage](#usage)
- [Examples](#examples)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Terraform module which creates **a kms keyring** or reuses an existing one on **Google Cloud Provider**.
It enables using an external keyring as required for S3NS

## User Stories for this module

- AAOps I can get my key ring with `module.key_ring.key_ring` whether I want to create a new one or reuse an existing one

## Usage

```hcl
# existing key ring
module "key_ring" {
  source = "../.."

  project_id             = "project-id"
  key_ring_location      = "europe-west9"
  existing_key_ring_name = "gke-s3ns-test-keyring"
}


resource "google_kms_crypto_key" "this" {
  name                       = "key-name"
  key_ring                   = module.key_ring.key_ring.id
  rotation_period            = "7890000s" # 3 months
  destroy_scheduled_duration = "604800s"  # 7 days

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
}
```

## Examples

All examples are in the examples folder:

- [Example of an existing keyring](examples/existing/main.tf)
- [Example of a new keyring](examples/new/main.tf)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_kms_key_ring.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |
| [google_kms_key_ring.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/kms_key_ring) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_existing_key_ring_name"></a> [existing\_key\_ring\_name](#input\_existing\_key\_ring\_name) | The name of a key ring that already exists | `string` | `""` | no |
| <a name="input_key_ring_location"></a> [key\_ring\_location](#input\_key\_ring\_location) | The location of the key ring | `string` | n/a | yes |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | The name of the key ring to create | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where the key ring should be created / exists | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_ring"></a> [key\_ring](#output\_key\_ring) | The key ring resource |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
