#####
# Boostrap biwarden
#####
mkdir -p /var/bitwarden/data/;

# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# sudo apt-get update && sudo apt-get install consul
# sudo apt-get update && sudo apt-get install consul-enterprise.x86_64
# consul agent \
#   -bind=172.20.20.11 \
#   -enable-script-checks=true \
#   -data-dir=/tmp/consul \
#   -config-dir=/etc/consul.d
