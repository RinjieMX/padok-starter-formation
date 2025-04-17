# Google Terraform module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Terraform module which creates **Service Account(s)** resources on **Google Cloud Platform**.

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name                                                                                                     | Description                                                                                                     | Type           | Default | Required |
| -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name)                                 | Name displayed in the IAM page                                                                                  | `string`       | n/a     |   yes    |
| <a name="input_name"></a> [name](#input\_name)                                                           | Name of the service account                                                                                     | `string`       | n/a     |   yes    |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id)                                       | The project to deploy the ressources to.                                                                        | `string`       | n/a     |   yes    |
| <a name="input_bucket_roles"></a> [bucket\_roles](#input\_bucket\_roles)                                 | Roles that will be set at bucket scope on buckets passed like {BUCKET}=>{ROLE}                                  | `list(string)` | `[]`    |    no    |
| <a name="input_external_project_roles"></a> [external\_project\_roles](#input\_external\_project\_roles) | Roles that will be set at project scope on projects passed like {PROJECT\_ID}=>{ROLE}                           | `list(string)` | `[]`    |    no    |
| <a name="input_members"></a> [members](#input\_members)                                                  | Defines members that can use this service\_account using a role passed like {MEMBER}=>{ROLE}                    | `list(string)` | `[]`    |    no    |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles)                              | Roles that will be set at project scope on project\_id provided variable                                        | `list(string)` | `[]`    |    no    |
| <a name="input_secret_roles"></a> [secret\_roles](#input\_secret\_roles)                                 | Roles that will be set at secret scope on secrets passed like {SECRET\_ID}=>{ROLE}                              | `list(string)` | `[]`    |    no    |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles)    | Roles that will be set at service\_account scope on service\_account passed like {SERVICE\_ACCOUNT\_ID}=>{ROLE} | `list(string)` | `[]`    |    no    |

## Outputs

| Name                                             | Description                |
| ------------------------------------------------ | -------------------------- |
| <a name="output_this"></a> [this](#output\_this) | Service Account attributes |
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
