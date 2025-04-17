# cloud-run-app module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Introduction](#introduction)
- [Usage](#usage)
  - [Setup env variables](#setup-env-variables)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

This module deploys a cloud run (cloud run v2) with a specific service account. This cloud run connects to a vpc serverless connector and can access to differents databases, memorystore or buckets.

## Usage

### Setup env variables

No env variables are configured and cannot be configured through this module. The aim is to allow developpers to configure it through their CI/CD for example.

This is to avoid a conflict between the infrastructure code and the app deployment.

**Example with github action:**

1. Setup the github actions:

    ```yaml
    jobs:
      deploy-cloud-run:
        environment: ${{ inputs.env }}
        runs-on: ubuntu-latest
        steps:
          - name: 'Checkout'
            uses: actions/checkout@v4

          - name: Authentification
            id: 'auth'
            uses: 'google-github-actions/auth@v2'
            with:
              token_format: 'access_token'
              workload_identity_provider: ${{ inputs.workload_identity_provider }} # this is the output provider_name from the TF module
              service_account: ${{ inputs.service_account_email }} # this is a SA email configured using the TF module

          - name: read secrets from file
            if: ${{ inputs.add_secrets_to_cloud_run }}
            id: secrets-from-file
            run: |
              secrets_vars=$(for i in $(cat .github/cloud-run/.${{ inputs.service_name }}.secrets.${{ inputs.env }}); do echo -e "$i," | tr -d '\n'; done)
              echo "secrets_vars=${secrets_vars::-1}" >> "$GITHUB_OUTPUT"

          - id: 'deploy'
            uses: 'google-github-actions/deploy-cloudrun@v2'
            with:
              service: ${{ inputs.service_name }}
              image: ${{ inputs.image }}
              project_id: ${{ inputs.project_id }}
              region: ${{ inputs.region }}
              env_vars_update_strategy: overwrite
              secrets_update_strategy: overwrite
              env_vars_file: ".github/cloud-run/.${{ inputs.service_name }}.${{ inputs.env }}" # This should be remplace by the same mechanism as the secrets
              secrets: ${{ steps.secrets-from-file.outputs.secrets_vars || '' }}
    ```

1. Create some files in `.github/cloud-run` that will contains the environment variables and secrets

    If the cloud run is called myservice. Create a first file named `.myservice.<name of the environment>` that will contains env variables:

    ```ini
    MY_VAR_1=toto
    MY_VAR_2=tata
    ```

    Create a second file named `.myservice.secrets.<name of the environment>` that will contain the secret variables (optional):

    ```ini
    MY_SECRET_ENV_VAR_NAME_1=my_gcp_secret_variable_name_1:latest
    MY_SECRET_ENV_VAR_NAME_2=my_gcp_secret_variable_name_2:4
    ```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name                                                                      | Version |
| ------------------------------------------------------------------------- | ------- |
| <a name="provider_google"></a> [google](#provider\_google)                | n/a     |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a     |

## Modules

| Name                                                                                | Source                                                                   | Version |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | ------- |
| <a name="module_redis"></a> [redis](#module\_redis)                                 | git@github.com:terraform-google-modules/terraform-google-memorystore.git | v12.0.0 |
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | git@github.com:padok-team/terraform-google-serviceaccount.git            | v2.0.1  |
| <a name="module_sql"></a> [sql](#module\_sql)                                       | git@github.com:padok-team/terraform-google-sql.git//modules/postgresql   | v0.7.0  |

## Resources

| Name                                                                                                                                                            | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [google-beta_google_cloud_run_v2_service.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_service) | resource    |
| [google_cloud_run_service_iam_binding.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_binding)       | resource    |
| [google_storage_bucket.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)                                     | resource    |
| [google_storage_bucket_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member)               | resource    |
| [google_compute_subnetwork.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork)                          | data source |

## Inputs

| Name                                                                              | Description                                                               | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Default                                                                                                                                                                       | Required |
| --------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_buckets"></a> [buckets](#input\_buckets)                           | List of the buckets managed by the Terraform code                         | <pre>map(object({<br/>    name       = string<br/>    versioning = bool<br/>  }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | `{}`                                                                                                                                                                          |    no    |
| <a name="input_cloud_run"></a> [cloud\_run](#input\_cloud\_run)                   | Object describing the Cloud Run app itself                                | <pre>object({<br/>    generate_revision_name = optional(bool, true)<br/>    service_labels         = optional(map(string), {})<br/>    service_annotations    = optional(map(string), {})<br/>    command                = optional(list(string), [])<br/>    args                   = optional(list(string), [])<br/>    ports = optional(object({<br/>      name = string<br/>      port = number<br/>      }), {<br/>      name = "http1"<br/>      port = 8080<br/>    })<br/>    limits                           = optional(map(string), {})<br/>    requests                         = optional(map(string), {})<br/>    container_concurrency            = optional(number, null)<br/>    timeout_seconds                  = optional(number, 120)<br/>    template_labels                  = optional(map(string), {})<br/>    template_annotations             = optional(map(string), {})<br/>    registry_project_ids             = optional(list(string), [])<br/>    members                          = optional(list(string), ["allUsers"])<br/>    min_instance_count               = optional(number, 1)<br/>    max_instance_count               = optional(number, 50)<br/>    env                              = optional(map(string), {})<br/>    max_instance_request_concurrency = optional(number)<br/>  })</pre> | n/a                                                                                                                                                                           |   yes    |
| <a name="input_databases"></a> [databases](#input\_databases)                     | List of the databases managed by the Terraform code                       | <pre>map(object({<br/>    tier              = string<br/>    availability_type = string<br/>    engine_version    = string<br/>    public            = bool<br/>    backup_region     = string<br/>  }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `{}`                                                                                                                                                                          |    no    |
| <a name="input_name"></a> [name](#input\_name)                                    | Name of the Cloud Run app                                                 | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | n/a                                                                                                                                                                           |   yes    |
| <a name="input_network"></a> [network](#input\_network)                           | Object containing information about the network hosting the Cloud Run app | <pre>object({<br/>    subnet_self_link               = string<br/>    gcp_peering_connection         = string<br/>    vpc_access_connector_self_link = string<br/>    ingress                        = string<br/>  })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | <pre>{<br/>  "gcp_peering_connection": null,<br/>  "ingress": "INGRESS_TRAFFIC_ALL",<br/>  "subnet_self_link": null,<br/>  "vpc_access_connector_self_link": null<br/>}</pre> |    no    |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id)                | ID of the project hosting the Cloud Run app                               | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | n/a                                                                                                                                                                           |   yes    |
| <a name="input_redis"></a> [redis](#input\_redis)                                 | List of the Redis instances managed by the Terraform code                 | <pre>map(object({<br/>    tier    = string<br/>    memory  = number<br/>    version = string<br/>  }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `{}`                                                                                                                                                                          |    no    |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account used by the Cloud Run app                                 | <pre>object({<br/>    project_roles          = list(string) # list of {ROLE}<br/>    external_project_roles = list(string) # using format {PROJECT_ID}=>{ROLE}<br/>    bucket_roles           = list(string) # using format {BUCKET}=>{ROLE}<br/>    secret_roles           = list(string) # using format {SECRET_ID}=>{ROLE}<br/>    service_account_roles  = list(string) # using format {SERVICE_ACCOUNT_ID}=>{ROLE}<br/>  })</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | <pre>{<br/>  "bucket_roles": [],<br/>  "external_project_roles": [],<br/>  "project_roles": [],<br/>  "secret_roles": [],<br/>  "service_account_roles": []<br/>}</pre>       |    no    |

## Outputs

| Name                                                                                                                  | Description |
| --------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_cloud_run_url"></a> [cloud\_run\_url](#output\_cloud\_run\_url)                                       | n/a         |
| <a name="output_gcloud_run_deploy_command"></a> [gcloud\_run\_deploy\_command](#output\_gcloud\_run\_deploy\_command) | n/a         |
<!-- END_TF_DOCS -->
