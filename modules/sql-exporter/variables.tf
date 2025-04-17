variable "name" {
  type        = string
  description = "Unique name to give to all created resources."
}

variable "project_id" {
  type        = string
  description = "The Google project ID."
}

variable "region" {
  type        = string
  description = "The region of your SQL instance."
}

variable "lifecycle_rules" {
  type = list(object({
    condition = object({
      age = string
    })
    action = object({
      storage_class = string
    })
  }))
  description = "The lifecycle rules to use for the export bucket."
  # This is the lifecycle policy recommended here https://cloud.google.com/blog/topics/developers-practitioners/scheduling-cloud-sql-exports-using-cloud-functions-and-cloud-scheduler?hl=en
  default = [
    {
      condition = {
        age = "30"
      }
      action = {
        storage_class = "NEARLINE"
      }
    },
    {
      condition = {
        age = "90"
      }
      action = {
        storage_class = "COLDLINE"
      }
    },
    {
      condition = {
        age = "365"
      }
      action = {
        storage_class = "ARCHIVE"
      }
    }
  ]
}
