resource "google_compute_instance" "control_command" {
  name         = "control-command"
  machine_type = "g1-small"
  tags = ["consul-member", "consul-master"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210927"
    }
  }

  network_interface {
    # network = google_compute_network.vpc_network.name
    # access_config {
    # }
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = file("auth/google_compute_engine.pub")
  }

  metadata_startup_script = file("config/startup-scripts/startup-command_control.sh")

  connection {
    type     = "ssh"
    user     = "root"
    private_key = file("auth/google_compute_engine")
    host     = self.network_interface[0].access_config[0].nat_ip
  }

  provisioner "file" {
    content     = templatefile("config/ressources/hosts.tftpl", {tag_map = local.instances_tag_map})
    destination = "hosts"
  }

  provisioner "file" {
    content     = file("auth/google_compute_engine")
    destination = "google_compute_engine"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 500 google_compute_engine"
    ]
  }

}

resource "google_compute_instance" "containers" {
  for_each = local.gce_container_configs
  name = each.key
  machine_type = "g1-small"
  tags = ["http-server", "https-server", "consul-member", "consul-slave", "coos", each.key]

  metadata = {
    gce-container-declaration = file(each.value)
  }
  metadata_startup_script = templatefile("config/startup-scripts/startup-containers.sh", {
    cloud_public_key = "${file("auth/google_compute_engine.pub")}",
    startup_container_script = "startup-${each.key}.sh"
  })

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-93-16623-102-4"
    }
  }
  network_interface {
    # network = google_compute_network.vpc_network.name
    # access_config {
    # }
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}

# resource "google_compute_instance" "dashboard" {
#   name         = "dashboard"
#   machine_type = "g1-small"
#   tags = ["http-server", "https-server", "consul-member", "consul-slave", "coos"]

#   boot_disk {
#     initialize_params {
#       image = "cos-cloud/cos-93-16623-102-4"
#     }
#   }


#   network_interface {
#     # network = google_compute_network.vpc_network.name
#     # access_config {
#     # }
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   service_account {
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     gce-container-declaration = file("config/gce-container-configs/homer-gce-container.yml")
#   }
#   metadata_startup_script = file("config/startup-scripts/startup-dashboard.sh")
# }

# resource "google_compute_instance" "bitwarden" {
#   name         = "bitwarden"
#   machine_type = "g1-small"
#   tags = ["http-server","https-server", "consul-member", "consul-slave", "coos"]

#   boot_disk {
#     initialize_params {
#       image = "cos-cloud/cos-93-16623-102-4"
#     }
#   }


#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   service_account {
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     gce-container-declaration = file("config/gce-container-configs/bitwarden-gce-container.yml")
#   }

#   metadata_startup_script = file("config/startup-scripts/startup-pass.sh")

# }
