terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("auth/hashicorp-test-338415-5ec89b1f01db.json")

  project = "hashicorp-test-338415"
  region  = "us-central1"
  zone    = "us-central1-c"
}
