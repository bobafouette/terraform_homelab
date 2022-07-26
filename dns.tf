
resource "google_dns_managed_zone" "lab" {
  name     = "lab"
  dns_name = "lab.blocker.rocks."
  lifecycle {
    prevent_destroy = true
    ignore_changes = [name, dns_name]
  }
}

resource "google_dns_record_set" "lets_encrypt_caa_record" {
  name = "lab.blocker.rocks."
  type = "CAA"
  ttl  = 300
  managed_zone = google_dns_managed_zone.lab.name

  rrdatas = ["0 issue \"letsencrypt.org\""]
}

resource "google_dns_record_set" "container_a_reccords" {
  for_each = google_compute_instance.containers
  name = "${each.value.name}.${google_dns_managed_zone.lab.dns_name}"

  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.lab.name

  rrdatas = [each.value.network_interface[0].access_config[0].nat_ip]
}

resource "google_dns_record_set" "container_cname_records" {
  for_each = {for service, hostname in transpose(local.gce_containers): service => hostname[0]}
  name = "${each.key}.${google_dns_managed_zone.lab.dns_name}"

  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.lab.name

  rrdatas = ["${each.value}.${google_dns_managed_zone.lab.dns_name}"]
}

# resource "google_dns_record_set" "frontend" {
#   name = "frontend.${google_dns_managed_zone.lab.dns_name}"
#   type = "A"
#   ttl  = 300

#   managed_zone = google_dns_managed_zone.lab.name

#   rrdatas = [google_compute_instance.dashboard.network_interface[0].access_config[0].nat_ip]
# }

# resource "google_dns_record_set" "pass" {
#   name = "pass.${google_dns_managed_zone.lab.dns_name}"
#   type = "A"
#   ttl  = 300

#   managed_zone = google_dns_managed_zone.lab.name

#   rrdatas = [google_compute_instance.bitwarden.network_interface[0].access_config[0].nat_ip]
# }
