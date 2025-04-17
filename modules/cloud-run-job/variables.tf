variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "name" {
  description = "The name of the Cloud Run job to create"
  type        = string
}

variable "location" {
  description = "Cloud Run job deployment location"
  type        = string
}

variable "image" {
  description = "GCR hosted image URL to deploy"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello-job"
}

variable "argument" {
  type        = list(string)
  description = "Arguments passed to the ENTRYPOINT command, include these only if image entrypoint needs arguments"
  default     = []
}

variable "container_command" {
  type        = list(string)
  description = "Leave blank to use the ENTRYPOINT command defined in the container image, include these only if image entrypoint should be overwritten"
  default     = []
}

variable "launch_stage" {
  type        = string
  description = "The launch stage. (see https://cloud.google.com/products#product-launch-stages). Defaults to GA."
  default     = ""
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the Cloud Run job."
}

variable "max_retries" {
  type        = number
  default     = null
  description = "Number of retries allowed per Task, before marking this Task failed."
}

variable "parallelism" {
  type        = number
  default     = null
  description = "Specifies the maximum desired number of tasks the execution should run at given time. Must be <= taskCount."
}

variable "task_count" {
  type        = number
  default     = null
  description = "Specifies the desired number of tasks the execution should run."
}

variable "volumes" {
  type = list(object({
    name = string
    cloud_sql_instance = object({
      instances = set(string)
    })
  }))
  description = "A list of Volumes to make available to containers."
  default     = []
}

variable "volume_mounts" {
  type = list(object({
    name       = string
    mount_path = string
  }))
  description = "Volume to mount into the container's filesystem."
  default     = []
}

variable "vpc_access" {
  type = list(object({
    connector_id = string                                  # Id of the vpc access connector. Format: projects/{project}/locations/{location}/connectors/{connector},
    egress       = optional(string, "PRIVATE_RANGES_ONLY") # Shoud be either ALL_TRAFIC or PRIVATE_RANGES_ONLY
  }))
  description = "VPC Access configuration to use for this Task."
  default     = []
}

variable "limits" {
  type = object({
    cpu    = optional(string)
    memory = optional(string)
  })
  description = "Resource limits to the container"
  default     = null
}

variable "timeout" {
  type        = string
  description = "Max allowed time duration the Task may be active before the system will actively try to mark it failed and kill associated containers."
  default     = "600s"
  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]{1,9})?s$", var.timeout))
    error_message = "The value must be a duration in seconds with up to nine fractional digits, ending with 's'. Example: \"3.5s\"."
  }
}

variable "type" {
  default     = "exec"
  type        = string
  description = "Define which type of job to deploy. Either schedule or exec"
  validation {
    condition     = contains(["exec", "schedule"], var.type)
    error_message = "The value must be either 'schedule' or 'exec'"
  }
}

variable "scheduler" {
  type = object({
    description      = optional(string, null)           # Description of the Cloud Scheduler
    schedule         = string                           # Follow the format here: https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules#cron_job_format
    attempt_deadline = string                           # The deadline for job attempts
    retry_count      = number                           # The number of attempts that the system will make (max 5)
    paused           = optional(bool, false)            # Pause the cloud scheduler. Can be use when deploying a new project
    region           = optional(string, "europe-west3") # Region where to deploy the cloud scheduler. Warning: cloud scheduler is not available in all regions
  })
  description = "Scheduler configuration. Warning: cloud scheduler is not available in all regions."
  default = {
    attempt_deadline = "320s"
    schedule         = "0 0 23 * *"
    retry_count      = 3
  }
}

variable "cicd_service_account_list" {
  type        = list(string)
  description = "List of service account that can deploy the cloud run job"
  default     = []
}

variable "env_secrets" {
  type = list(object({
    name    = string
    secret  = string
    version = optional(string, "latest")
    role    = optional(string, "roles/secretmanager.secretAccessor")
  }))
  default     = []
  description = "list of secrets to deploy into cloudrun"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection on the Cloud Run job"
  default     = true
}
