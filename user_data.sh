#!/bin/bash

# Atualizando o sistema e instalando e habilitando o docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Download do dockerfile com wordpress
wget "a definir"

# Criando imagem docker a partir do dockerfile
docker build -t wordpress-image -f Dockerfile.

# Criando container wordpress
docker run -d --name my-wordpress-container -p 80:80 my-wordpress-image

# Instalando o cliente MySQL
yum install -y mysql

# Configurar o WordPress para se conectar ao banco de dados RDS MySQL
docker exec -it my-wordpress-container bash -c "yum install -y mysql"
docker exec -it my-wordpress-container wp config create --dbname=DB_NAME --dbuser=DB_USER --dbpass=DB_PASSWORD --dbhost=DB_HOST

...
