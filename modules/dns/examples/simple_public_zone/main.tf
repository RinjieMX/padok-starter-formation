# Basic DNS configuration with a public zone and a set of common types of records

provider "google" {
  project = "gcp-library-terratest"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}

module "simple_public_zone" {
  source = "../.."

  project_id = "gcp-library-terratest"

  name = "padok-simple-public-zone"
  fqdn = "test.library.padok.fr."
  records = {
    "rec1" = {
      name    = "www"
      type    = "A"
      rrdatas = ["35.189.202.112"]
      ttl     = 60
    }
    "rec2" = {
      name    = "sql"
      type    = "CNAME"
      rrdatas = ["pf2-mysql.online.net."]
      ttl     = 60
    }
    "rec3" = {
      name = ""
      type = "MX"
      rrdatas = [
        "1 aspmx.l.google.com.",
        "5 alt1.aspmx.l.google.com.",
        "5 alt2.aspmx.l.google.com.",
        "10 alt3.aspmx.l.google.com.",
        "10 alt4.aspmx.l.google.com.",
      ]
      ttl = 60
    }
  }
}
