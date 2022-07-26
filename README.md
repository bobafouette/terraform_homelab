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
I could not find any official documentation on this subject but CoOS instances allows us to pass configurations for our main container into the metadata of the instances. However this method was not extremely effective because it would not allow to start multiple containers on the same host at startup.

## Issues

### COOS, Ansible & host inventory

I am having an issue with handling coos machine configuration right:
To configure COOS host's containers it is necessary to use an ssh docker container: a python3 is running inside it and allows to install tools to control containers via ansible from the inside of this container.

The issue is that this container has it's ssh server listenning on port 2222, to access it we must configure ansible to connect to this port and then configure it back to standard port 22 so we can run next playbook on it without impacting it's run.
However I could not find an idempotent way to apply this architecture.
We would need to have different hosts, or group that configure a port for this machine maybe via the `ansible_port` variable.


## Todo:
- ~~Find an elegant solution to upload notion's API_KEY into the cron-machine~~
- Deploy a SMTP web server
- Deploy a matrix (synapse, postgre, element) setup.
- Need to streamline deployement of secure tokens...
- Test Nomad [ON HOLD]
  - Replace Container optimized os Instances by regular ubuntu instances
  - Deploy Consul and Nomad on them
  - Add Firewall rule to allow HTTP UI acces on the Nomad instance (port `4646`)
  - Schedule containers via Nomad's docker plugin on those instances
- ~~Traefik/nginx reverse proxy~~: This is installed locally on coos instances. Might switch later to cluster deployment via consul or swarm.
- Deploy Vault [ON HOLD]
- Deploy Boundary [ON HOLD]
- ...?