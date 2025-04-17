locals {
  kubernetes_sa_prefix = "serviceAccount:${var.context.project_id}.svc.id.goog"
}

module "external_secrets" {
  source       = "../service-account"
  name         = "external-secrets"
  display_name = "External Secrets service account"

  project_id = var.context.project_id

  project_roles = [
    "roles/secretmanager.secretAccessor"
  ]
  members = [
    "${local.kubernetes_sa_prefix}[external-secrets/external-secrets]=>roles/iam.workloadIdentityUser"
  ]
  depends_on = [module.gke]
}

module "cert_manager" {
  source       = "../service-account"
  name         = "cert-manager"
  display_name = "Cert Manager service account"

  project_id = var.context.project_id

  project_roles = [
    "roles/dns.admin",
  ]
  members = [
    "${local.kubernetes_sa_prefix}[cert-manager/cert-manager]=>roles/iam.workloadIdentityUser"
  ]
  depends_on = [module.gke]
}
