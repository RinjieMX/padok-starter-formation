terraform {
  required_version = "~> 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.49"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
