#####
# Boostrap homer dashboard
#####
mkdir -p /var/homer/config/
wget -O /var/homer/config/config.yml https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/services-configs/homer.conf.yml
wget -O /var/homer/config/logo.png https://raw.githubusercontent.com//bastienwirtz/homer/main/public/logo.png

wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/ressources/sshd_config
mkdir /var/ssh/
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSvZz+2ls2CDBnZzvKmvhy1/Kq/YrhDAOVAcafMWzfhJEZoNvbQ1Szg4sVVG7N4RBl8m/1xqqcmbTsJyDqRol/rJxmFeuieW/VX9HNsRVy4rmBaz3sNYbgAjM3pMfx2yk2QXVGTKzFUvXgPh+6+SacEp/bDfNXQFxAQYzfuKJ5qD9GMrJ4YWuR7TpgrPeaQPJuKrUOVuBFtKs+Diq7j0ZzCr4R/baVktu16mmUt5z6cCfzNMrBH9da6QpP26svu85AmkwykhkUJZBUMnVQ1LvrG2up5kFDopTpDnGzMf4r3TLdNaRffbERfkLxpx3QZUXUg/rxIQKSWeOvYSOs3oOV root@a4122299c78b" > /var/ssh/authorized_keys
systemctl restart sshd

docker run -d -p 2222:2222 -v /var/run/docker.sock:/var/run/docker.sock -v /var/ssh/:/ssh_keys -e PUBLIC_KEY_FILE=/ssh_keys/authorized_keys -e USER_NAME=dev -e SUDO_ACCESS=true -e HOSTNAME=$HOSTNAME --name sshd lscr.io/linuxserver/openssh-server
docker exec sshd apk add --update --no-cache python3
docker exec sshd ln -sf python3 /usr/bin/python3.6
docker exec sshd python3.6 -m ensurepip
docker exec sshd python3.6 -m pip install docker
