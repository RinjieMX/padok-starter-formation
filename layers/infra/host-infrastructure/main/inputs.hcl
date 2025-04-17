inputs = {
  context = {
    networks = {
      manong-non-production = local.non_production_network
      manong-production     = local.production_network
    }
  }
}

locals {
  non_production_network = {
    # Name of the network to create (should be the same as the map key)
    name = "manong-non-production"
    # Create a bastion with following configuration
    bastion = {
      subnet  = "172.17.32.8/29"
      region  = "europe-west4"
      members = ["user:manon.gardin@theodo.com"]
    }
    subnets = {
      # One entry by subnet to create
      staging = {
        # Name of the subnet to create (should be the same as the map key)
        name = "manong-staging"
        # One region by subnet
        region = "europe-west4"
        # Primary CIDR for the subnet
        primary_cidr = "172.17.24.0/21"
        # Serverless CIDR for the subnet, it can be empty if you don't plan to use a serverless network
        serverless_cidr = "192.168.132.0/28"
        # List the secondary ranges to link to the subnet
        secondary_ranges = {}
      },
    },
    # CIDR to reserve for GCP service in this VPC
    gcp_peering_cidr = "172.17.8.0/21"
  }
  production_network = {
    name = "manong-production"
    bastion = {
      subnet  = "172.17.32.0/29"
      region  = "europe-west4"
      members = ["user:manon.gardin@theodo.com"]
    }
    subnets = {
      production = {
        name            = "manong-production"
        region          = "europe-west4"
        primary_cidr    = "172.17.16.0/21"
        serverless_cidr = "192.168.132.16/28"
        connector_specs = {
          machine_type = "e2-standard-4"
        }
        secondary_ranges = {}
      },
    },
    gcp_peering_cidr = "172.17.0.0/21"
  }
  registry = {
    region           = "europe-west4"
    github_orga_name = "padok-team"
    github_repo_name = "infra-registry"
    repo_name        = "infra-registry"
  }
}
