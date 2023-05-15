#!/bin/bash
#############################################################################################
# ADICIONAR SWAPFILE
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
#############################################################################################
# ADICIONAR MEMORIA COMPARTILHADA - Possibilita a comunicação entre processos (IPC), 
# onde diferentes processos podem compartilhar e se comunicar através de uma area de 
# memoria comum, que neste caso geralmente é um arquivo normal que é armazenado em um "ramdisk".
sudo echo "none /run/shm tmpfs defaults,ro 0 0" >> /etc/fstab
sudo mount -a
#############################################################################################
# INSTALAR DEPENDENCIAS
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
#############################################################################################
# INSTALAR DOCKER ARM64 E DOCKER-COMPOSE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update
sudo apt install docker-ce -y
sudo apt install docker-compose -y
#############################################################################################
# CRIAR DIRETORIO E ARQUIVO "acme.json" PARA RECEBER O CERTIFICADO SSL
sudo mkdir -p /home/ubuntu/pritunl/letsencrypt
sudo touch /home/ubuntu/pritunl/letsencrypt/acme.json
sudo chmod 600 /home/ubuntu/pritunl/letsencrypt/acme.json
#############################################################################################
# ALTERAR TIMEZONE
sudo timedatectl set-timezone America/Sao_Paulo
#############################################################################################
# INSTALAR AWS CLI ARM
cd /tmp
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo unzip awscliv2.zip
sudo ./aws/install
#############################################################################################
# COPIAR docker-compose.yml e traefik.yml (tls 1.2 e 1.3) para composição do docker.
aws s3 cp s3://aldeiacloud-pritunl-docker/docker-compose.yml /home/ubuntu/pritunl/
aws s3 cp s3://aldeiacloud-pritunl-docker/traefik.yml /home/ubuntu/pritunl/
cd /home/ubuntu/pritunl/
sudo docker-compose up -d
#############################################################################################
#OBS:
#1- Fazer apontamento do IP elástico a ser usado para o subdomínio da VPN. (Ex.: vpn.aldeiacloud.com.br)
#2- Criar bucket para colocar os arquivos "docker-compose.yml" e "traefik.yml".
#3- Configurar uma role que tenha acesso ao bucket criado e aponta-los corretamente no codigo acima.
#4- Ao subir, atachar rapidamente o ip elástico apontado no Route53, para o traefik gerar o SSL.
