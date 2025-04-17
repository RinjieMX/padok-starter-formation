output "gke_command_to_connect" {
  description = "The command to use to connect to GKE cluster."
  value       = module.gke.command_to_connect
}

output "external_secrets_service_account" {
  description = "External Secrets service account email"
  value       = "Email: ${module.external_secrets.this.email}, Expected Namespace: external-secrets, Expected K8S SA name: external-secrets"
}

output "cert_manager_service_account" {
  description = "Cert Manager service account email"
  value       = "Email: ${module.cert_manager.this.email}, Expected Namespace: cert-manager, Expected K8S SA name: cert-manager"
}

output "iap_load_balancer_annotation" {
  description = "Annotation to add to your Ingress to have a static IP"
  value       = "kubernetes.io/ingress.global-static-ip-name: ${google_compute_global_address.iap_lb_ip.name}"
}

output "non_iap_load_balancer_annotation" {
  description = "Annotation to add to your Ingress to have a static IP"
  value       = "kubernetes.io/ingress.global-static-ip-name: ${google_compute_global_address.non_iap_lb_ip.name}"
}

output "ssl_policy_name" {
  description = "Name of the SSL policy to use for the load balancers"
  value       = "Name: ${google_compute_ssl_policy.this.name}, add this to your FrontendConfig object"
}

output "iap_client" {
  description = "IAP Client ID"
  value       = "Client ID Secret Manager name: ${google_secret_manager_secret.iap_id.name}, Client Secret Secret Manager name: ${google_secret_manager_secret.iap_secret.name}"
}
