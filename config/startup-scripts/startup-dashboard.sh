#####
# Boostrap homer dashboard
#####
mkdir -p /var/homer/config/
wget -O /var/homer/config/config.yml https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/homer.conf.yml
wget -O /var/homer/config/logo.png https://raw.githubusercontent.com//bastienwirtz/homer/main/public/logo.png

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
