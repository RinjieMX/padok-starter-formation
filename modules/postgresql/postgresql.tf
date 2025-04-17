# Select a zone randomly
resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.this.names
  result_count = 1
}

# Instance
module "postgresql_db" {
  #checkov:skip=CKV_GCP_110:Ensure pgAudit is enabled for your GCP PostgreSQL database
  # Skipped because it doesn't need to be an option in the module below.
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "23.0.0"

  name                 = var.name # Mandatory
  random_instance_name = true
  #checkov:skip=CKV_GCP_79:Ensure SQL database is using latest Major version
  # Skipped because it's in a variable
  database_version = var.engine_version # Mandatory
  project_id       = var.project_id     # Mandatory
  zone             = var.zone
  region           = var.region
  tier             = var.tier
  user_labels      = var.labels

  db_charset   = var.db_charset
  db_collation = var.db_collation

  # Storage
  disk_autoresize = true
  disk_size       = 10
  disk_type       = var.disk_type

  # Configuration
  #checkov:skip=CKV2_GCP_13:Ensure PostgreSQL database flag 'log_duration' is set to 'on'
  #checkov:skip=CKV_GCP_51:Ensure PostgreSQL database 'log_checkpoints' flag is set to 'on'
  #checkov:skip=CKV_GCP_52:Ensure PostgreSQL database 'log_connections' flag is set to 'on'
  #checkov:skip=CKV_GCP_53:Ensure PostgreSQL database 'log_disconnections' flag is set to 'on'
  #checkov:skip=CKV_GCP_54:Ensure PostgreSQL database 'log_lock_waits' flag is set to 'on'
  #checkov:skip=CKV_GCP_111:Ensure GCP PostgreSQL logs SQL statements
  #checkov:skip=CKV_GCP_108:Ensure hostnames are logged for GCP PostgreSQL databases
  #checkov:skip=CKV_GCP_109:Ensure the GCP PostgreSQL database log levels are set to ERROR or lower
  #checkov:ship=CKV2_GCP_13:Ensure PostgreSQL database flag 'log_duration' is set to 'on'
  # Skipped because it's in a variable, and merging the list of objects wasn't working
  database_flags = var.database_flags

  # High Availability
  availability_type = var.availability_type

  # Backup
  #checkov:skip=CKV_GCP_14:Ensure all Cloud SQL database instance have backup configuration enabled
  # Skipped because it's enabled but in a local variable
  backup_configuration = local.backup_configuration

  # Replicas
  read_replicas = local.replicas

  # Users
  enable_default_user = false
  additional_users    = [for user in local.users_passwords : merge(user, { type = "BUILT_IN" })]

  # Databases
  enable_default_db    = false
  additional_databases = length(var.databases) == 0 ? [] : local.additional_databases

  # Instance
  deletion_protection = var.instance_deletion_protection

  # Encryption
  encryption_key_name = var.encryption_key_id

  # Network
  #checkov:skip=CKV_GCP_60:Ensure Cloud SQL database does not have public IP
  #checkov:skip=CKV_GCP_6:Ensure all Cloud SQL database instance requires all incoming connections to use SSL
  # Skipped because it's in a local variable
  ip_configuration = local.ip_configuration

  # Terraform timeout
  create_timeout = "20m"
}
