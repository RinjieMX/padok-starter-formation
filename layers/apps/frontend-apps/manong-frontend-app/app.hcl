inputs = {
  name = "${local.root.locals.username}-frontend-app"
  domain_name   = "frontend.${local.module.locals.environment}.${local.root.locals.username}.padawan.padok.cloud"
  dns_zone_name = "gcp-library"
}
