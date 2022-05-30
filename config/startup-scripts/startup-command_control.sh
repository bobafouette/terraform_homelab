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


# Wait for ansible's inventory and private key to be uploaded
while [ ! -f /root/hosts ] || [ ! -f /root/google_compute_engine ]; do echo "waiting for ansible inventory and private key"; sleep 2; done
# Apply ansible role consul on consul cluster members
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i /root/hosts --private-key /root/google_compute_engine /ansible_gcp/playbooks/cron-machine.yml
