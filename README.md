# Terraform Homelab

## Motivation

This repo serves mainly as a sandbox to experiment with terraform and other tools in the hashicorp ecosystem.  
The idea is to use terraform to dynamically generate a inventory file. It will generate ansible groups based on the tags applied by terraform on the different gcp instances.

## Interesting tricks

### Consul deployement via ansible and containers
I wanted to use consul in this repository to create a sevice mesh.  
Therefore I needed a way to automate the installation of consul on those CoOS hosts.  
Google's container optimized OS does not allow package installation. Preventing us from installing Docker's python SDK required by ansible to directly pilot docker containers.

I used a sshd container based on alpine linux to start a ssh box on the port 2222, started with a bind mount on the docker socket.  
This allowed me to install python3 with docker's python SDK in the container, which ansible then uses to pilot the containers inside the CoOS instance.

### Automate ssh trusted public keys deployment in CoOS instances
Another tricky thing with google container's optimized OS is that it's filesystem main's part is readonly: only some subparts of it is writable (see: https://cloud.google.com/container-optimized-os/docs/concepts/disks-and-filesystem).
This seems to prevent installation of keys inside root's home via provided metadata.
To prevent this I had to push an adapted configuration for sshd at statup and point to a custom path to look for authorized_keys before pushing the keys into this file via the startup script.

### Use metadata to automate container startup inside CoOS instances
I could not find any official documentation on this subject but CoOS instances allows us to pass configurations for our main container into the metadata of the instances.  


## Todo:
- Fix ansible first execution
- Reduce specifix setup made in startup scripts
- Minimalized startup scripts (mutualized startup script for all CoOS instances)
- Dynamic coos instances creations (using foreach and count operators)
- Traefik/nginx reverse proxy based on consul
- Test Nomad
- ...?