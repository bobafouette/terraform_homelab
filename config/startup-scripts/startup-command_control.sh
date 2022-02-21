#####
# Boostrap ANSIBLE
#####
# Install Ansible
sudo apt update
sudo apt install software-properties-common --yes
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible --yes
# Clone playbooks
git clone https://github.com/bobafouette/ansible_gcp.git

# Update ansible configuration
echo "[defaults]" >> /etc/ansible/ansible.cfg
echo "remote_tmp = /tmp/ansible" >> /etc/ansible/ansible.cfg
# Install ansible community's docker module
ansible-galaxy collection install community.docker

#####
# Boostrap Consul Server
#####
# Install source
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul
sudo apt-get update && sudo apt-get install consul-enterprise.x86_64
# Start Consul agent
consul agent \
  -server \
  -bootstrap-expect=1 \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d &

# Wait for ansible's inventory and private key to be uploaded
while [ ! -f /root/hosts ] || [ ! -f /root/google_compute_engine ]; do echo "waiting for ansible inventory and private key"; sleep 2; done
# Apply ansible role consul on consul cluster members
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i /root/hosts --private-key /root/google_compute_engine /ansible_gcp/playbooks/consul.yml
