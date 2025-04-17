variable "name" {
  description = "The name of the Cloud SQL resource."
  type        = string
}

variable "project_id" {
  description = "The project ID to manage the Cloud SQL resource."
  type        = string
}

variable "region" {
  description = "Region for the master instance."
  type        = string
  validation {
    condition     = length(split("-", var.region)) == 2
    error_message = "This is not a region."
  }
}

variable "availability_type" {
  description = "Is CloudSQL instance Regional or Zonal correct values = (REGIONAL|ZONAL)."
  type        = string
  validation {
    condition     = var.availability_type == "REGIONAL" || var.availability_type == "ZONAL"
    error_message = "Availability_type only supports REGIONAL or ZONAL."
  }
  default = "REGIONAL"
}

variable "engine_version" {
  description = "The version of MySQL engine. Check https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version for possible versions."
  type        = string
  default     = "MYSQL_8_0"
}

variable "tier" {
  description = "The database tier (db-f1-micro, db-custom-cpu-ram)."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
}

variable "disk_type" {
  description = "The disk type (PD_SSD, PD_HDD)."
  type        = string
  default     = "PD_SSD"
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings."
  default     = {}
  type        = any
}

variable "replicas" {
  description = "The replicas instance names and configuration."
  type        = map(any)
  default     = {}
}

variable "db_collation" {
  description = "Collation for the DB."
  type        = string
  default     = "utf8_general_ci" # MySQL Charset support: https://dev.mysql.com/doc/refman/8.0/en/charset-mysql.html
}

variable "db_charset" {
  description = "Charset for the DB."
  type        = string
  default     = "utf8" # MySQL Charset support: https://dev.mysql.com/doc/refman/8.0/en/charset-mysql.html
}

variable "instance_deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = false
}

variable "databases" {
  description = "List of the default DBs you want to create."
  type = map(object({
    export_backup   = bool
    export_schedule = optional(string, "0 2 * * *")
  }))
  default = {}
}

variable "users" {
  description = "List of the User's name you want to create (passwords will be auto-generated). Warning! All those users will be admin and have access to all databases created with this module."
  type        = list(string)
}

variable "users_host" {
  description = "value"
  type        = string
  default     = ""
}

variable "database_flags" {
  description = "Database configuration flags."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "public" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  type        = bool
  default     = false
}

variable "require_ssl" {
  description = "Set to false if you don not want to enforce SSL (less secure)."
  type        = bool
  default     = true
}

variable "private_network" {
  description = "The vpc id to create the instance into."
  type        = string
}

variable "allocated_ip_range" {
  description = "The name of the allocated ip range for the private ip CloudSQL instance. For example: \"google-managed-services-default\". If set, the instance ip will be created in the allocated range."
  type        = string
  default     = null
}

variable "create_secrets" {
  description = "Do we create the secrets in secret manager?"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to add to the CloudSQL and its replicas."
  type        = map(string)
  default     = {}
}

variable "encryption_key_id" {
  description = "The full path to the encryption key used for the CMEK disk encryption. The provided key must be in the same region as the SQL instance. If not provided, a KMS key will be generated."
  type        = string
  default     = null
}

variable "key_ring_name" {
  description = "The name of an existing keyring in which we will create keys used for the CMEK disk encryption. The provided keyring must be in the same region as the SQL instance. If not provided, one will be generated."
  type        = string
  default     = ""
}

variable "key_ring_project_id" {
  description = "The project ID in which the keyring is located. If not provided, the project_id variable will be used."
  type        = string
  default     = null
}

variable "encryption_key_rotation_period" {
  description = "The encryption key rotation period for the CMEK disk encryption. The provided key must be in the same region as the SQL instance. If encryption_key_id is defined, this variable is not used."
  type        = string
  default     = "7889400s" # 3 months
}

variable "sql_exporter" {
  description = "The SQL exporter to use for backups if needed."
  type = object({
    bucket_name  = string
    pubsub_topic = string
    timezone     = optional(string, "UTC")
  })
  default = null
}

variable "init_custom_sql_script" {
  type        = string
  description = "sql script to execute"
  default     = ""
}

variable "zone" {
  type        = string
  description = "zone in which to deploy the database"
}
