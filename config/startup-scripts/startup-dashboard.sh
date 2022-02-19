#####
# Boostrap homer dashboard
#####
mkdir -p /var/homer/config/
wget -O /var/homer/config/config.yml https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/services-configs/homer.conf.yml
wget -O /var/homer/config/logo.png https://raw.githubusercontent.com//bastienwirtz/homer/main/public/logo.png

wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/ressources/sshd_config
mkdir /var/ssh/
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSvZz+2ls2CDBnZzvKmvhy1/Kq/YrhDAOVAcafMWzfhJEZoNvbQ1Szg4sVVG7N4RBl8m/1xqqcmbTsJyDqRol/rJxmFeuieW/VX9HNsRVy4rmBaz3sNYbgAjM3pMfx2yk2QXVGTKzFUvXgPh+6+SacEp/bDfNXQFxAQYzfuKJ5qD9GMrJ4YWuR7TpgrPeaQPJuKrUOVuBFtKs+Diq7j0ZzCr4R/baVktu16mmUt5z6cCfzNMrBH9da6QpP26svu85AmkwykhkUJZBUMnVQ1LvrG2up5kFDopTpDnGzMf4r3TLdNaRffbERfkLxpx3QZUXUg/rxIQKSWeOvYSOs3oOV root@a4122299c78b" > /var/ssh/authorized_keys

# #####
# # Boostrap Consul
# #####
# # Install source
# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# sudo apt-get update && sudo apt-get install consul
# sudo apt-get update && sudo apt-get install consul-enterprise.x86_64
# # Start Consul agent
# consul agent \
#   -server \
#   -bootstrap-expect=1 \
#   -data-dir=/tmp/consul \
#   -config-dir=/etc/consul.d
