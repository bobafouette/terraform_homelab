#####
# Mount persistent storage
#####
mount /var/docker-peristant-sto


#####
# Boostrap container configuration
#####
wget -O /tmp/${startup_container_script} https://raw.githubusercontent.com/bobafouette/terraform_homelab/main/config/startup-scripts/${startup_container_script}
bash /tmp/${startup_container_script}
