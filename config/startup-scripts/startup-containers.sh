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
# Mount persistant drive
#####
lsblk -o fstype /dev/disk/by-id/google-docker-peristant-str | grep ext4 || mkfs.ext4 /dev/disk/by-id/google-docker-peristant-str
mkdir -p /var/docker-peristant-sto
echo "/dev/disk/by-id/google-docker-peristant-str /var/docker-peristant-sto ext4 defaults 0 0" >> /etc/fstab


#####
# Create a certificate for this host
#####
# This is not working as the new DNS record is not propagated at this point to our recently created IP address
docker run --rm --name certbot -p 80:80 -v /var/letsencrypt:/etc/letsencrypt/ certbot/certbot certonly --standalone --noninteractive  --agree-tos --preferred-challenges http --email loup.kreidl@gmail.com -d ${hostname}.lab.blocker.rocks --logs-dir /etc/letsencrypt/logs

#####
# Boostrap container configuration
#####
wget -O /tmp/${startup_container_script} https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/startup-scripts/${startup_container_script}
bash /tmp/${startup_container_script}
