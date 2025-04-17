# Select a zone randomly
resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.this.names
  result_count = 1
}

# Instance
module "mysql_db" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "23.0.0"

  name                 = var.name # Mandatory
  random_instance_name = true

  #checkov:skip=CKV_GCP_79:Ensure SQL database is using latest Major version
  # Skipped because it's in a variable
  database_version = var.engine_version # Mandatory

  project_id  = var.project_id # Mandatory
  zone        = var.zone
  region      = var.region
  tier        = var.tier
  user_labels = var.labels

  db_charset   = var.db_charset
  db_collation = var.db_collation

  # Storage
  disk_autoresize = true
  disk_size       = 10
  disk_type       = var.disk_type

  # Configuration
  database_flags = var.database_flags

  # High Availability
  availability_type = var.availability_type

  #checkov:skip=CKV_GCP_14:Ensure all Cloud SQL database instance have backup configuration enabled
  # Skipped because it's enabled but in a local variable

  # Backup
  backup_configuration = local.backup_configuration
  #checkov:skip=CKV2_GCP_20:Ensure MySQL DB instance has point-in-time recovery backup configured
  # Skipped because it costs money so is an opt-in feature

  # Replicas
  read_replicas = local.replicas

  # Users
  enable_default_user = false
  additional_users    = [for user in local.users_passwords : merge(user, { type = "BUILT_IN", host = var.users_host })]

  # Databases
  enable_default_db    = false
  additional_databases = length(var.databases) == 0 ? [] : local.additional_databases

  # Instance
  deletion_protection = var.instance_deletion_protection

  # Encryption
  encryption_key_name = var.encryption_key_id

  #checkov:skip=CKV_GCP_60:Ensure Cloud SQL database does not have public IP
  #checkov:skip=CKV_GCP_6:Ensure all Cloud SQL database instance requires all incoming connections to use SSL
  # Skipped because it's in a local variable

  # Network
  ip_configuration = local.ip_configuration

  # Terraform timeout
  create_timeout = "20m"
}
