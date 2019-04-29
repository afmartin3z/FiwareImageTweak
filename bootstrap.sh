#!/bin/bash

## 
## Install Docker
##
dhclient ens3
apt-get -y update 

apt-get dist-upgrade  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options="--force-confold" -y


apt-get install -y \
   apt-transport-https \
   ca-certificates \
   software-properties-common \
   curl \
   lsof \
   vim

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get -y update
apt-get install -y docker-ce


apt -y clean
apt -y autoremove
## 
## Install Docker-compose
##
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

export DEBIAN_FRONTEND=noninteractivce 
# apt full-upgrade -o Dpkg::Options::="--force-confdef" -o Dpkg::Options="--force-confold" -y
apt-get dist-upgrade  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options="--force-confold" -y
apt-get clean
apt-get -y autoremove

