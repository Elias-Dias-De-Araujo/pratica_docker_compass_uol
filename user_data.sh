#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# Esta linha de curl do yml não está funcionando adequadamente
#curl -L "https://github.com/Elias-Dias-De-Araujo/pratica_docker_compass_uol/blob/main/docker-compose.yml" -o /home/ec2-user/docker-compose.yml
usermod -aG docker ${USER}
chmod 666 /var/run/docker.sock
docker-compose -f /home/ec2-user/docker-compose.yml up -d
