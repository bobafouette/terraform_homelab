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

# resource "google_compute_network" "vpc_network" {
#   name = "terraform-network"
# }

resource "google_compute_instance" "control_command" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

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
  # metadata_startup_script = "useradd adminuser && chpasswd <<<'adminuser:test' && usermod -aG sudo adminuser && apt install openssh-server && sudo apt-add-repository universe && sudo apt update && sudo apt install -y google-compute-engine google-osconfig-agent"
}

resource "google_compute_instance" "dashy" {
  name         = "dashy"
  machine_type = "g1-small"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-93-16623-102-4"
    }
  }

  provisioner "file" {
    source      = "config/dashy.conf.yml"
    destination = "/var/dashy/config/conf.yml"

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("auth/google_compute_engine")
      host     = "${self.network_interface.0.access_config.0.nat_ip}"
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
    gce-container-declaration = file("config/dashy-gce-container.yml")
    # enable-osconfig = "TRUE"
  }
  metadata_startup_script = "mkdir -p /var/dashy/config/"
}

output "name" {
  value = google_compute_instance.dashy.name
}