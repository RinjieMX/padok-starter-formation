module "gke" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_GCP_74: cannot enforce private_ip_google_access using Google's VPC module
  #checkov:skip=CKV_GCP_76: cannot enforce IPV6 private access using Google's VPC module
  source = "../.."

  name       = "terratest-network-gke"
  project_id = "padok-cloud-factory"

  subnets = {
    "eu" = {
      name            = "eu"
      region          = "europe-west1"
      primary_cidr    = "172.16.48.0/20"
      serverless_cidr = ""
      secondary_ranges = {
        pods = {
          name = "gke-pods-main"
          cidr = "10.8.0.0/14"
        },
        services = {
          name = "gke-services-main"
          cidr = "192.168.6.0/23"
        }
      }
    }
  }
  gcp_peering_cidr = "172.16.64.0/20"
}
