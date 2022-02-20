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
echo "[defaults]" >> /etc/ansible/ansible.cfg
echo "remote_tmp = /tmp/ansible" >> /etc/ansible/ansible.cfg
ansible-galaxy collection install community.docker
sudo ansible-playbook -i hosts --private-key google_compute_engine /ansible_gcp/playbooks/consul.yml -vvv

#####
# Boostrap Consul
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
  -config-dir=/etc/consul.d
