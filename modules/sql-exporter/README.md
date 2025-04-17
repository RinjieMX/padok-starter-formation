# Google Cloud SQL (Sql Exporter) Terraform module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [User Stories for this module](#user-stories-for-this-module)
- [Usage](#usage)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Providers](#providers-1)
- [Modules](#modules-1)
- [Resources](#resources-1)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Terraform module which creates **a storage bucket**, **a function app** and **a pub sub** resources on **GCP** to export SQL backups from GCP SQL instances.

## User Stories for this module

- AASRE my databases backups are exported in a storage bucket.

## Usage

This module must be used in combination with [mysql module](../mysql/) or [postgresql module](../postgresql/). It creates the necessary ressources to export sql backups in a storage account, however it does not handle the schedule for these backups. This part is handled in SQL modules, where you can enable and configure backup for your databases.

```hcl
module "my-sql-exporter" {
  source = "https://github.com/padok-team/terraform-google-sql/modules/sql-exporter"

  name = "my-exporter-1"

  project_id = "my-project-id"
  region     = "europe-west3"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.11 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_function"></a> [function](#module\_function) | terraform-google-modules/event-function/google | ~> 2.3.0 |
| <a name="module_pubsub"></a> [pubsub](#module\_pubsub) | terraform-google-modules/pubsub/google | ~> 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.11 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_function"></a> [function](#module\_function) | terraform-google-modules/event-function/google | ~> 2.3.0 |
| <a name="module_pubsub"></a> [pubsub](#module\_pubsub) | terraform-google-modules/pubsub/google | ~> 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The lifecycle rules to use for the export bucket. | <pre>list(object({<br>    condition = object({<br>      age = string<br>    })<br>    action = object({<br>      storage_class = string<br>    })<br>  }))</pre> | <pre>[<br>  {<br>    "action": {<br>      "storage_class": "NEARLINE"<br>    },<br>    "condition": {<br>      "age": "30"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": "COLDLINE"<br>    },<br>    "condition": {<br>      "age": "90"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": "ARCHIVE"<br>    },<br>    "condition": {<br>      "age": "365"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name to give to all created resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Google project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region of your SQL instance. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the bucket in which export files will be kept |
| <a name="output_pubsub_topic"></a> [pubsub\_topic](#output\_pubsub\_topic) | The pubsub topic id |
