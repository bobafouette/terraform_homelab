resource "google_compute_instance" "control_command" {
  name         = "control-command"
  machine_type = "g1-small"
  ## Removed http tags to avoid REST API backdoors
  ## Removed consul-tags as well
  # tags = ["http-server", "https-server", "consul-member", "consul-master"]
  ##
  # tags = ["cron-machine"]

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

  provisioner "file" {
    content     = file("auth/notion_api.key")
    destination = "notion_api.key"
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
  tags = ["http-server", "https-server", "coos", each.key]

  # Removed in favor of ansible provisionning allowing more fine grained setup
  # metadata = {
  #   # See https://github.com/GoogleCloudPlatform/konlet/blob/9cb9106daf07123c2641159cb8bcc9d6f4960ec2/gce-containers-startup/types/api.go#L30
  #   gce-container-declaration = file(each.value)
  # }
  metadata_startup_script = templatefile("config/startup-scripts/startup-containers.sh", {
    cloud_public_key = "${file("auth/google_compute_engine.pub")}",
    startup_container_script = "startup-${each.key}.sh",
    hostname = each.key
  })

  attached_disk {
    source = google_compute_disk.docker_peristant_str.name
    device_name = "docker-peristant-str"
  }

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

resource "google_compute_instance" "cron-machine" {
  name = "cron-machine"
  machine_type = "g1-small"
  tags = ["cron-machine"]

  metadata = {
    ssh-keys = file("auth/google_compute_engine.pub")
  }

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
}
