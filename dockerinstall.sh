#!/bin/bash
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update
sudo apt install docker-ce -y
sudo curl -L https://github.com/docker/compose/releases/download/1.28.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mkdir -p /home/ubuntu/pritunl/letsencrypt
sudo touch /home/ubuntu/pritunl/letsencrypt/acme.json
sudo chmod 600 /home/ubuntu/pritunl/letsencrypt/acme.json
cd /home/ubuntu/pritunl/
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo timedatectl set-timezone America/Sao_Paulo
sudo apt install snapd -y
sudo snap install aws-cli --classic
aws s3 cp s3://aldeiacloud-pritunl-docker/docker-compose.yml /home/ubuntu/pritunl/
aws s3 cp s3://aldeiacloud-pritunl-docker/traefik.yml /home/ubuntu/pritunl/
sudo docker-compose up -d
#
#OBS:
#1- Fazer apontamento do IP elástico a ser usado para o subdomínio da VPN. (Ex.: vpn.aldeiacloud.com.br)
#2- Criar bucket para colocar os arquivos "docker-compose.yml" e "traefik.yml".
#3- Configurar uma role que tenha acesso ao bucket criado e aponta-los corretamente no codigo acima.
#4- Ao subir, atachar rapidamente o ip elástico apontado no Route53, para o traefik gerar o SSL.
