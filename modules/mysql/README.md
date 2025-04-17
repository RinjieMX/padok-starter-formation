# Google Cloud SQL (MySQL) Terraform module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [User Stories for this module](#user-stories-for-this-module)
- [Usage](#usage)
- [Execute your SQL script](#execute-your-sql-script)
- [Examples](#examples)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Terraform module which creates **MYSQLDB** resources on **GCP**. This module is an abstraction of the [terraform-google-sql for MySQL](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest/submodules/postgresql) by Google itself.

## User Stories for this module

- AAUser I can deploy a public MySQL Database
- AAUser I can deploy a private MySQL Database within a VPC
- AAUser I can deploy a MySQL Database with N replica
- AAUser I can deploy a MySQL Database with/without TLS encryption
- AAUser I can deploy a cloud scheduler which launches exports with an already existing pubsub function
- AAUser I can encrypt the database with my own encryption key

<em>By default, deployed Database is in HA mode, with a 7 retention days backup strategy.</em>

## Usage

```hcl
module "my-private-mysql-db" {
  source = "https://github.com/padok-team/terraform-google-sql/modules/mysql"

  name              = "my-private-mysql-db1" # Mandatory
  engine_version    = "MYSQL_8_0"            # Mandatory
  project_id        = local.project_id       # Mandatory
  region            = "europe-west1"         # Mandatory
  availability_type = "ZONAL"

  disk_limit = 20

  users          = ["User_1", "User_2"]
  create_secrets = true

  backup_configuration = {
    enabled  = true
    location = "europe-west3"
  }

  databases = {
    "MYDB_1" = {
      backup = false
    }
  }

  private_network = module.my_network.network_id

  custom_sql_script = <<EOT
REVOKE ALL PRIVILEGES ON *.* FROM 'User_1'@'';
GRANT ALL PRIVILEGES ON MYDB_1.* TO 'User_1'@'';
EOT
}
```

## Execute your SQL script

If you have set a custom sql script, you need to execute it. As for now, terraform doesn't allow to execute the sql script, you need to use the [gcloud command instead](https://cloud.google.com/sdk/gcloud/reference/sql/import/sql)

```bash
gcloud sql import sql my-private-postgres-db1 MY-BUCKET --project=MY-PROJECT -q
```

## Examples

- [MySQL instance private and zonal](examples/mysql_private_zonal)
- [MySQL instance public and regional](examples/mysql_public_regional)
- [MySQL instance public, zonal, with backup exporter](examples/mysql_public_with_exporter)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_ring"></a> [key\_ring](#module\_key\_ring) | ../key-ring | n/a |
| <a name="module_mysql_db"></a> [mysql\_db](#module\_mysql\_db) | GoogleCloudPlatform/sql-db/google//modules/mysql | 23.0.0 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_kms_crypto_key_iam_member.crypto_key](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_kms_crypto_key_iam_member) | resource |
| [google-beta_google_project_service_identity.gcp_sa_cloud_sql](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_cloud_scheduler_job.exporter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_kms_crypto_key.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_secret_manager_secret.password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_storage_bucket.script](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.exporter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.script_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object.sql_script](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_shuffle.zone](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [terraform_data.sql_script](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [google_compute_zones.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_ip_range"></a> [allocated\_ip\_range](#input\_allocated\_ip\_range) | The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the instance ip will be created in the allocated range. | `string` | `null` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | Is CloudSQL instance Regional or Zonal correct values = (REGIONAL\|ZONAL). | `string` | `"REGIONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration settings subblock for the database setings. | `any` | `{}` | no |
| <a name="input_create_secrets"></a> [create\_secrets](#input\_create\_secrets) | Do we create the secrets in secret manager? | `bool` | `true` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | Database configuration flags. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | List of the default DBs you want to create. | <pre>map(object({<br/>    export_backup   = bool<br/>    export_schedule = optional(string, "0 2 * * *")<br/>  }))</pre> | `{}` | no |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | Charset for the DB. | `string` | `"utf8"` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | Collation for the DB. | `string` | `"utf8_general_ci"` | no |
| <a name="input_disk_limit"></a> [disk\_limit](#input\_disk\_limit) | The maximum size to which storage can be auto increased. | `number` | n/a | yes |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type (PD\_SSD, PD\_HDD). | `string` | `"PD_SSD"` | no |
| <a name="input_encryption_key_id"></a> [encryption\_key\_id](#input\_encryption\_key\_id) | The full path to the encryption key used for the CMEK disk encryption. The provided key must be in the same region as the SQL instance. If not provided, a KMS key will be generated. | `string` | `null` | no |
| <a name="input_encryption_key_rotation_period"></a> [encryption\_key\_rotation\_period](#input\_encryption\_key\_rotation\_period) | The encryption key rotation period for the CMEK disk encryption. The provided key must be in the same region as the SQL instance. If encryption\_key\_id is defined, this variable is not used. | `string` | `"7889400s"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version of MySQL engine. Check https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version for possible versions. | `string` | `"MYSQL_8_0"` | no |
| <a name="input_init_custom_sql_script"></a> [init\_custom\_sql\_script](#input\_init\_custom\_sql\_script) | sql script to execute | `string` | `""` | no |
| <a name="input_instance_deletion_protection"></a> [instance\_deletion\_protection](#input\_instance\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `false` | no |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | The name of an existing keyring in which we will create keys used for the CMEK disk encryption. The provided keyring must be in the same region as the SQL instance. If not provided, one will be generated. | `string` | `""` | no |
| <a name="input_key_ring_project_id"></a> [key\_ring\_project\_id](#input\_key\_ring\_project\_id) | The project ID in which the keyring is located. If not provided, the project\_id variable will be used. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to add to the CloudSQL and its replicas. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud SQL resource. | `string` | n/a | yes |
| <a name="input_private_network"></a> [private\_network](#input\_private\_network) | The vpc id to create the instance into. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to manage the Cloud SQL resource. | `string` | n/a | yes |
| <a name="input_public"></a> [public](#input\_public) | Set to true if the master instance should also have a public IP (less secure). | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for the master instance. | `string` | n/a | yes |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The replicas instance names and configuration. | `map(any)` | `{}` | no |
| <a name="input_require_ssl"></a> [require\_ssl](#input\_require\_ssl) | Set to false if you don not want to enforce SSL (less secure). | `bool` | `true` | no |
| <a name="input_sql_exporter"></a> [sql\_exporter](#input\_sql\_exporter) | The SQL exporter to use for backups if needed. | <pre>object({<br/>    bucket_name  = string<br/>    pubsub_topic = string<br/>    timezone     = optional(string, "UTC")<br/>  })</pre> | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The database tier (db-f1-micro, db-custom-cpu-ram). | `string` | `"db-f1-micro"` | no |
| <a name="input_users"></a> [users](#input\_users) | List of the User's name you want to create (passwords will be auto-generated). Warning! All those users will be admin and have access to all databases created with this module. | `list(string)` | n/a | yes |
| <a name="input_users_host"></a> [users\_host](#input\_users\_host) | value | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | zone in which to deploy the database | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the master instance to be used in connection strings. |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The instance name for the master instance. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The id of encryption key. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The first private IPv4 address assigned for the master instance. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The first public (PRIMARY) IPv4 address assigned for the master instance. |
| <a name="output_read_replica_instance_names"></a> [read\_replica\_instance\_names](#output\_read\_replica\_instance\_names) | The instance names for the read replica instances. |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | The secrets created for the users. |
| <a name="output_users"></a> [users](#output\_users) | List of maps of users and passwords. |
<!-- END_TF_DOCS -->
