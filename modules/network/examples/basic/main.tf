module "basic" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_GCP_74: cannot enforce private_ip_google_access using Google's VPC module
  #checkov:skip=CKV_GCP_76: cannot enforce IPV6 private access using Google's VPC module
  source = "../.."

  name       = "terratest-network-basic"
  project_id = "padok-cloud-factory"

  nats = {
    "europe-west1" = {
      mode      = "DYNAMIC_PORT_ALLOCATION"
      min_ports = 64
      max_ports = 2048
    }
    "europe-west2" = {
      min_ports = 1024
    }
  }

  subnets = {

    "eu-1" = {
      name             = "eu-1"
      region           = "europe-west1"
      primary_cidr     = "172.16.0.0/20"
      serverless_cidr  = ""
      secondary_ranges = {}
    },
    "eu-2" = {
      name             = "eu-2"
      region           = "europe-west2"
      primary_cidr     = "172.16.48.0/20"
      serverless_cidr  = "172.16.80.0/28"
      secondary_ranges = {}
    }
    "us" = {
      name             = "us"
      region           = "northamerica-northeast1"
      primary_cidr     = "172.16.96.0/20"
      serverless_cidr  = ""
      secondary_ranges = {}
    }
  }
  gcp_peering_cidr = "172.16.64.0/20"
}
