resource "google_compute_resource_policy" "daily_backup_policy" {
  name   = "daily-backup-policy"
  region = "us-central1"

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "01:00"
      }
    }
    retention_policy {
      max_retention_days    = 2
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      guest_flush = true
    }
  }
}

resource "google_compute_disk" "docker_peristant_str" {
  name = "docker-peristant-str"
  type = "pd-ssd"
  lifecycle {
    prevent_destroy = true
    ignore_changes = ["name", "type"]
  }
}

resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.daily_backup_policy.name
  disk = google_compute_disk.docker_peristant_str.name
}