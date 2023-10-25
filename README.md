# PRÁTICA DOCKER - COMPASS.UOL

A atividade consiste em:
1. instalação e configuração do DOCKER ou CONTAINERD no host EC2; Ponto adicional para o trabalho utilizar a instalação via script de Start Instance (user_data.sh) 
2. Efetuar Deploy de uma aplicação Wordpress com: container de aplicação RDS database Mysql 
3. Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação Wordpress 
4. Configuração do serviço de Load Balancer AWS para a aplicação Wordpress


# AWS - CONFIGURAÇÃO

As subseções seguintes contém as étapas de configuração da infraestrutura no ambiente da Amazon Web Services.

## VPC

A VPC desta atividade esta dividida entre duas tabelas de rotas, em que uma é dedicada para as subnets privadas e a outra para as subnets públicas, existem duas subnets privadas e duas públicas, a criação das duas privadas é para conter o container docker com o wordpress, para que ele possa ser disponibilizado em um endereço ip privado e não em um público. Ademais, as duas subnets públicas estão criadas para permitir que o load balancer consiga conectar-se a internet a partir das duas AZs que elas estão localizadas ( São em AZs diferentes ), para assim, aumentar a disponibilidade.

Por fim, a tabela de rotas públicas possuí um internet gateway para acessar a internet e a tabela de rotas privadas possuí um NAT gateway para permitir o tráfego apenas de saída mas não de entrada.

## Security Group

Para essa atividade foram criados três grupos de segurança:

SG para EC2:

|Tipo|Protocolo|Porta|Origem|
|----------|-----|-----|----|
|SSH|TCP|22|0.0.0.0/0|
|HTTP|TCP|80|0.0.0.0/0|
|HTTPS|TCP|443|0.0.0.0/0|

SG para Load Balancer:

|Tipo|Protocolo|Porta|Origem|
|----------|-----|-----|----|
|HTTPS|TCP|443|0.0.0.0/0|
|HTTP|TCP|80|0.0.0.0/0|

SG para EFS:

|Tipo|Protocolo|Porta|Origem|
|----------|-----|-----|----|
|NFS|TCP|2049|0.0.0.0/0|

SG para RDS:

|Tipo|Protocolo|Porta|Origem|
|----------|-----|-----|----|
|MYSQL/Aurora|TCP|3306|SG-EC2
|MYSQL/Aurora|TCP|3306|177.37.230.130/32|

## Load Balancer

O Load Balancer escolhido para esta atividade foi o Application Load Balancer, devido a sua vantagem em comparação ao classic que é a utilização de target groups.

## Autoscaling


## EFS


## RDS



# SCRIPT E ARQUIVO DE IMAGEM .YAML

Para está seção, foi criado um arquivo .yaml no meu github pessoal e posteriormente eu chamo esse arquivo no user_data.sh que ficará no template de inicialização de cada uma das máquinas que será inicializada no autoscaling.

```yaml
version: '3.7'
services:
  wordpress:
    image: wordpress
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: database-docker-project.ckgdhkqntfx2.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: admin321
      WORDPRESS_DB_NAME: databaseDockerProject
    volumes:
      - /mnt/efs/wordpress:/var/www/html
```

O user_data.sh consiste em:

```sh
# Responsável por atualizar o sistema
sudo yum update -y
# Instalar o docker
sudo yum install docker -y
# Inicializar o docker
sudo systemctl start docker
# Habilitar o docker juntamente do início da instância
systemctl enable docker
# Dar um curl no docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Dar permissões necessárias
chmod +x /usr/local/bin/docker-compose
# Dar um curl no arquivo .yaml do meu git-hub e criar um arquivo de mesmo nome contendo seu conteúdo
curl -sL "https://raw.githubusercontent.com/Elias-Dias-De-Araujo/pratica_docker_compass_uol/main/docker-compose.yaml" --output "/home/ec2-user/docker-compose.yaml"
# Instalar cliente nfs 
yum install nfs-utils -y
# Criar diretório para montagem
mkdir /mnt/efs/
# Dar permissões necessárias ao diretório ( leitura, escrita e execução ) 
chmod +rwx /mnt/efs/
# Montar o sistema de arquivos com o EFS
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-07c68e847f4ea9744.efs.us-east-1.amazonaws.com:/ /mnt/efs/
# Habilitar montagem automatica quando a máquina inicializar
echo "fs-07c68e847f4ea9744.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs defaults 0 0" >> /etc/fstab
# Adicionar o usuário atual no grupo do docker
usermod -aG docker ${USER}
# Dar permissão de leitura e escrita no docker.sock
chmod 666 /var/run/docker.sock
# Criar o container com docker-compose utilizando a imagem do .yaml
docker-compose -f /home/ec2-user/docker-compose.yaml up -d
```
