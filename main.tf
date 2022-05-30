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

locals {
    ansible_instances = concat(
      [for container_instance in google_compute_instance.containers: container_instance],
      [google_compute_instance.cron-machine]
    )
    instances_tags = distinct(flatten([
        for instance in local.ansible_instances: instance.tags
    ]))
    instances_tag_map = {
        for tag in local.instances_tags: tag => [
            for instance in local.ansible_instances: instance.network_interface[0].network_ip if contains(instance.tags, tag)
        ]
    }

    gce_container_configs = {
      ## Commenting this part as those are not production ready for now
      # bitwarden = "config/gce-container-configs/bitwarden-gce-container.yml"
      # dashboard = "config/gce-container-configs/homer-gce-container.yml"
      ##
    }
}