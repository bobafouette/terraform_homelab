
output "containers_name" {
  value = [for container_instance in google_compute_instance.containers: container_instance.name]
}