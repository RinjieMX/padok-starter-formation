inputs = {
  name = "${local.root.locals.username}-backend-app"
  databases = {
    "${local.root.locals.username}-backend-postgres" = {
      tier              = "db-f1-micro"
      availability_type = "ZONAL"
      engine_version    = "POSTGRES_14"
      public            = false
      backup_region     = "europe-west1"
    }
  }
  redis = {
    "${local.root.locals.username}-backend-redis" = {
      tier    = "STANDARD_HA"
      memory  = 1
      version = null
    }
  }
}
