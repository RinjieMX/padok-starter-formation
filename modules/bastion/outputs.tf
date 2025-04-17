output "command_to_connect" {
  value       = "gcloud compute ssh --tunnel-through-iap --project ${var.project_id} --zone ${local.zone} ${google_compute_instance.bastion.name}"
  description = "Command to connect to the bastion's instance"
}
