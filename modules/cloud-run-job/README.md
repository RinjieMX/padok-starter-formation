# cloud-run-job module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Usage](#usage)
  - [Exec mode](#exec-mode)
  - [Scheduler mode](#scheduler-mode)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

This module allow to deploy a cloud run job, either in exec mode (started manually, without any trigger) or in scheduler mode, using GCP Cloud Scheduler.

## Usage

### Exec mode

```hcl
inputs = {
    project_id = "my_project"
    name       = "my-cloud-run-job"
    location   = "europe-west3"

    max_retries = 3
    parallelism = 1
    task_count  = 1

    limits = {
        cpu = "1"
        memory = "2Go"
    }

    type = "exec"
}
```

### Scheduler mode

```hcl
inputs = {
    project_id = "my_project"
    name       = "my-cloud-run-job"
    location   = "europe-west3"

    max_retries = 3
    parallelism = 1
    task_count  = 1

    limits = {
        cpu = "1"
        memory = "2Go"
    }

    type = "schedule"

    scheduler = {
        attempt_deadline = "320s"
        schedule         = "0 0 23 * *"
        retry_count      = 3
    }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_cloud_scheduler_job.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_scheduler_job) | resource |
| [google_cloud_run_v2_job.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job) | resource |
| [google_cloud_run_v2_job_iam_member.scheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job_iam_member) | resource |
| [google_secret_manager_secret_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_service_account.scheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_vpc_access_connector.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/vpc_access_connector) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argument"></a> [argument](#input\_argument) | Arguments passed to the ENTRYPOINT command, include these only if image entrypoint needs arguments | `list(string)` | `[]` | no |
| <a name="input_cicd_service_account_list"></a> [cicd\_service\_account\_list](#input\_cicd\_service\_account\_list) | List of service account that can deploy the cloud run job | `list(string)` | n/a | yes |
| <a name="input_container_command"></a> [container\_command](#input\_container\_command) | Leave blank to use the ENTRYPOINT command defined in the container image, include these only if image entrypoint should be overwritten | `list(string)` | `[]` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection on the Cloud Run job | `bool` | `true` | no |
| <a name="input_env_secrets"></a> [env\_secrets](#input\_env\_secrets) | list of secrets to deploy into cloudrun | <pre>list(object({<br/>    name    = string<br/>    secret  = string<br/>    version = optional(string, "latest")<br/>    role    = optional(string, "roles/secretmanager.secretAccessor")<br/>  }))</pre> | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | GCR hosted image URL to deploy | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the Cloud Run job. | `map(string)` | `{}` | no |
| <a name="input_launch_stage"></a> [launch\_stage](#input\_launch\_stage) | The launch stage. (see https://cloud.google.com/products#product-launch-stages). Defaults to GA. | `string` | `""` | no |
| <a name="input_limits"></a> [limits](#input\_limits) | Resource limits to the container | <pre>object({<br/>    cpu    = optional(string)<br/>    memory = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Cloud Run job deployment location | `string` | n/a | yes |
| <a name="input_max_retries"></a> [max\_retries](#input\_max\_retries) | Number of retries allowed per Task, before marking this Task failed. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud Run job to create | `string` | n/a | yes |
| <a name="input_parallelism"></a> [parallelism](#input\_parallelism) | Specifies the maximum desired number of tasks the execution should run at given time. Must be <= taskCount. | `number` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to deploy to | `string` | n/a | yes |
| <a name="input_scheduler"></a> [scheduler](#input\_scheduler) | Scheduler configuration. Warning: cloud scheduler is not available in all regions. | <pre>object({<br/>    description      = optional(string, null)           # Description of the Cloud Scheduler<br/>    schedule         = string                           # Follow the format here: https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules#cron_job_format<br/>    attempt_deadline = string                           # The deadline for job attempts<br/>    retry_count      = number                           # The number of attempts that the system will make (max 5)<br/>    paused           = optional(bool, false)            # Pause the cloud scheduler. Can be use when deploying a new project<br/>    region           = optional(string, "europe-west3") # Region where to deploy the cloud scheduler. Warning: cloud scheduler is not available in all regions<br/>  })</pre> | <pre>{<br/>  "attempt_deadline": "320s",<br/>  "retry_count": 3,<br/>  "schedule": "0 0 23 * *"<br/>}</pre> | no |
| <a name="input_task_count"></a> [task\_count](#input\_task\_count) | Specifies the desired number of tasks the execution should run. | `number` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Max allowed time duration the Task may be active before the system will actively try to mark it failed and kill associated containers. | `string` | `"600s"` | no |
| <a name="input_type"></a> [type](#input\_type) | Define which type of job to deploy. Either schedule or exec | `string` | `"exec"` | no |
| <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts) | Volume to mount into the container's filesystem. | <pre>list(object({<br/>    name       = string<br/>    mount_path = string<br/>  }))</pre> | `[]` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | A list of Volumes to make available to containers. | <pre>list(object({<br/>    name = string<br/>    cloud_sql_instance = object({<br/>      instances = set(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_access"></a> [vpc\_access](#input\_vpc\_access) | VPC Access configuration to use for this Task. | <pre>list(object({<br/>    connector_id = string                               # Id of the vpc access connector. Format: projects/{project}/locations/{location}/connectors/{connector},<br/>    egress    = optional(string, "PRIVATE_RANGES_ONLY") # Shoud be either ALL_TRAFIC or PRIVATE_RANGES_ONLY<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | Name of the Cloud Run Job. |
<!-- END_TF_DOCS -->
