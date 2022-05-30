#####
# Boostrap ssh container setup
#####

wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/ressources/sshd_config
mkdir /var/ssh/
echo ${cloud_public_key} > /var/ssh/authorized_keys
systemctl restart sshd

docker run -d -p 2222:2222 -v /var/run/docker.sock:/var/run/docker.sock -v /var/ssh/:/ssh_keys -e PUBLIC_KEY_FILE=/ssh_keys/authorized_keys -e USER_NAME=dev -e SUDO_ACCESS=true -e HOSTNAME=$HOSTNAME --name sshd lscr.io/linuxserver/openssh-server
docker exec sshd apk add --update --no-cache python3
docker exec sshd ln -sf python3 /usr/bin/python3.6
docker exec sshd python3.6 -m ensurepip
docker exec sshd python3.6 -m pip install docker

#####
# Boostrap container configuration
#####
wget -O /tmp/${startup_container_script} https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/startup-scripts/${startup_container_script}
bash /tmp/${startup_container_script}
