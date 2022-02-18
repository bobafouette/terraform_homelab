# locals {
#     ansible_instances = [
#         google_compute_instance.dashboard,
#         google_compute_instance.bitwarden
#     ]
#     instances_tags = distinct(flatten([
#         for instance in local.ansible_instances: instance.tags
#     ]))
#     instances_tag_map = {
#         for tag in local.instances_tags: tag => [
#             for instance in local.ansible_instances: instance.network_interface[0].network_ip if contains(instance.tags, tag)
#         ]
#     }
# }

# resource "local_file" "inventory" {
#     content = templatefile("config/ressources/hosts.tftpl", {tag_map = local.instances_tag_map})
#     filename = "config/ressources/hosts"
# }

# resource "google_compute_instance" "control_command" {

#     provisioner "file" {
#         content     = templatefile("config/ressources/hosts.tftpl", {tag_map = local.instances_tag_map})
#         destination = "/etc/ansible/hosts"
#     }

#     connection {
#     type     = "ssh"
#     user     = "root"
#     private_key = file("auth/google_compute_engine")
#     host     = self.network_interface[0].access_config[0].nat_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "ansible-playbook "
#     ]
#   }

# }