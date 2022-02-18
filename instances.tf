
resource "google_compute_instance" "control_command" {
  name         = "control-command"
  machine_type = "g1-small"

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
    ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSvZz+2ls2CDBnZzvKmvhy1/Kq/YrhDAOVAcafMWzfhJEZoNvbQ1Szg4sVVG7N4RBl8m/1xqqcmbTsJyDqRol/rJxmFeuieW/VX9HNsRVy4rmBaz3sNYbgAjM3pMfx2yk2QXVGTKzFUvXgPh+6+SacEp/bDfNXQFxAQYzfuKJ5qD9GMrJ4YWuR7TpgrPeaQPJuKrUOVuBFtKs+Diq7j0ZzCr4R/baVktu16mmUt5z6cCfzNMrBH9da6QpP26svu85AmkwykhkUJZBUMnVQ1LvrG2up5kFDopTpDnGzMf4r3TLdNaRffbERfkLxpx3QZUXUg/rxIQKSWeOvYSOs3oOV root@a4122299c78b"
    # enable-osconfig = "TRUE"
  }
  metadata_startup_script = file("config/startup-scripts/startup-command_control.sh")
}

resource "google_compute_instance" "dashboard" {
  name         = "dashboard"
  machine_type = "g1-small"
  tags = ["http-server","https-server"]

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

  metadata = {
    # ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSvZz+2ls2CDBnZzvKmvhy1/Kq/YrhDAOVAcafMWzfhJEZoNvbQ1Szg4sVVG7N4RBl8m/1xqqcmbTsJyDqRol/rJxmFeuieW/VX9HNsRVy4rmBaz3sNYbgAjM3pMfx2yk2QXVGTKzFUvXgPh+6+SacEp/bDfNXQFxAQYzfuKJ5qD9GMrJ4YWuR7TpgrPeaQPJuKrUOVuBFtKs+Diq7j0ZzCr4R/baVktu16mmUt5z6cCfzNMrBH9da6QpP26svu85AmkwykhkUJZBUMnVQ1LvrG2up5kFDopTpDnGzMf4r3TLdNaRffbERfkLxpx3QZUXUg/rxIQKSWeOvYSOs3oOV root@a4122299c78b"
    gce-container-declaration = file("config/gce-container-configs/homer-gce-container.yml")
    # enable-osconfig = "TRUE"
  }
  metadata_startup_script = file("config/startup-scripts/startup-dashboard.sh")
}

resource "google_compute_instance" "bitwarden" {
  name         = "bitwarden"
  machine_type = "g1-small"
  tags = ["http-server","https-server"]

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

  metadata = {
    # ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSvZz+2ls2CDBnZzvKmvhy1/Kq/YrhDAOVAcafMWzfhJEZoNvbQ1Szg4sVVG7N4RBl8m/1xqqcmbTsJyDqRol/rJxmFeuieW/VX9HNsRVy4rmBaz3sNYbgAjM3pMfx2yk2QXVGTKzFUvXgPh+6+SacEp/bDfNXQFxAQYzfuKJ5qD9GMrJ4YWuR7TpgrPeaQPJuKrUOVuBFtKs+Diq7j0ZzCr4R/baVktu16mmUt5z6cCfzNMrBH9da6QpP26svu85AmkwykhkUJZBUMnVQ1LvrG2up5kFDopTpDnGzMf4r3TLdNaRffbERfkLxpx3QZUXUg/rxIQKSWeOvYSOs3oOV root@a4122299c78b"
    gce-container-declaration = file("config/gce-container-configs/bitwarden-gce-container.yml")
    # enable-osconfig = "TRUE"
  }
  metadata_startup_script = file("config/startup-scripts/startup-pass.sh")
}
