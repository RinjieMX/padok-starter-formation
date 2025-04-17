locals {
  project_id = "gcp-library-terratest"
  region     = "europe-west3"
}

module "cloud_run" {
  source = "../.."

  name       = "ci-cloud-run-test"
  project_id = local.project_id
  location   = local.region
  cloud_run = {
    deletion_protection = false
    limits = {
      "cpu"    = "1000m"
      "memory" = "512Mi"
    }
  }
  network = {
    resource_link                  = "projects/gcp-library-terratest/global/networks/production"
    vpc_access_connector_self_link = "projects/gcp-library-terratest/locations/europe-west3/connectors/production-europe-west3-0"
    ingress                        = "INGRESS_TRAFFIC_ALL"
    gcp_peering_connection         = "gcp-services-peering-production"
  }
}

terraform {
  required_version = "~> 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.0"
    }
  }
}
