output "security_policy_id" {
  description = "The id of the Security Policy created"
  value       = google_compute_security_policy.this.id
}

output "security_policy_self_link" {
  description = "The self_link of the Security Policy created"
  value       = google_compute_security_policy.this.self_link
}
