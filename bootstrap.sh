#!/bin/bash

## 
## Install Docker
##
dhclient ens3
apt-get -y update 

DEBIAN_FRONTEND='noninteractive' apt-get dist-upgrade  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options="--force-confold" -y


apt-get install -y \
   apt-transport-https \
   ca-certificates \
   software-properties-common \
   curl \
   lsof \
   vim \
   docker \
   docker.io

apt -y clean
apt -y autoremove
## 
## Install Docker-compose
##
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker run --name mongo-orion -v /data/mongo:/data/db -d -h mongo-orion --restart unless-stopped mongo:3.6
docker run --name orion -d -p 1026:1026 --link mongo-orion --restart unless-stopped -h orion fiware/orion:latest -dbhost mongo-orion


docker run --name mongo -v /data/mongo-cygnus:/data/db -d -h mongo --restart unless-stopped mongo:3.6
docker run -d --name cygnus --link mongo -p 5080:5080 -p 5050:5050 -e CYGNUS_MONGO_HOSTS=mongo:27017 --restart unless-stopped fiware/cygnus-ngsi
