locals {
  project_id = "gcp-library-terratest"
  region     = "europe-west3"
}

resource "random_id" "main" {
  byte_length = 4
}

module "bastion" {
  source            = "../.."
  project_id        = local.project_id
  region            = local.region
  name              = "terratest-bastion-basic-${random_id.main.hex}"
  network_self_link = "projects/${local.project_id}/regions/${local.region}/networks/default"
  subnet_self_link  = "projects/${local.project_id}/regions/${local.region}/subnetworks/default"
  members           = ["user:aurelien.vungoc@theodo.com"]
}
