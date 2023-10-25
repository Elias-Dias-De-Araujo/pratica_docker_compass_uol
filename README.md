# PRÁTICA DOCKER - COMPASS.UOL

A atividade consiste em:
1. instalação e configuração do DOCKER ou CONTAINERD no host EC2; Ponto adicional para o trabalho utilizar a instalação via script de Start Instance (user_data.sh) 
2. Efetuar Deploy de uma aplicação Wordpress com: container de aplicação RDS database Mysql 
3. Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação Wordpress 
4. Configuração do serviço de Load Balancer AWS para a aplicação Wordpress

# AWS - CONFIGURAÇÃO

As subseções seguintes contém as étapas de configuração da infraestrutura no ambiente da Amazon Web Services.

## VPC

A VPC desta atividade está dividida entre duas tabelas de rotas, em que uma é dedicada para as subnets privadas e a outra para as subnets públicas, existem duas subnets privadas e duas públicas, a criação das duas privadas é para conter o container docker com o wordpress, para que ele possa ser disponibilizado em um endereço ip privado e não em um público. Ademais, as duas subnets públicas estão criadas para permitir que o load balancer consiga conectar-se a internet a partir das duas AZs que elas estão localizadas ( São em AZs diferentes ), para assim, aumentar a disponibilidade.

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


## Autoscaling


## EFS


## RDS

# SCRIPT E ARQUIVO DE IMAGEM .YAML
