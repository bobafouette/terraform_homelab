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
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

locals {
  ansible_instances = concat(
    [for container_instance in google_compute_instance.containers: container_instance],
    [google_compute_instance.cron-machine]
  )
  instances_tags = distinct(flatten([
      for instance in local.ansible_instances: instance.tags
  ]))
  container_tags =distinct(flatten([
    for tag in local.gce_containers: tag
  ]))
  instances_tag_map = {
      "container_tags": {
        for tag in local.container_tags: tag => [
            for instance in local.ansible_instances: instance.name if contains(instance.tags, tag)
        ]
      },
      "hosts_tags": {
        for tag in local.instances_tags: tag => [
            for instance in local.ansible_instances: instance.name if contains(instance.tags, tag)
        ] if !contains(local.container_tags, tag)
      }
  }

  gce_containers = {
    ## Commenting this part as those are not production ready for now
    "secrets": [ "bitwarden", "vault", "coos-web"]
    # dashboard = "config/gce-container-configs/homer-gce-container.yml"
    ##
  }
}
