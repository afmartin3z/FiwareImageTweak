#!/bin/bash

##
## Install Docker
##
dhclient ens3
DEBIAN_FRONTENT='noninteractive' apt-get -y update

DEBIAN_FRONTEND='noninteractive' apt-get dist-upgrade  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options="--force-confold" -y


DEBIAN_FRONTEND='noninteractive' apt-get install -y apt-transport-https ca-certificates software-properties-common curl lsof vim docker docker.io

DEBIAN_FRONTEND='noninteractive' apt -y clean
DEBIAN_FRONTEND='noninteractive' apt -y autoremove
##
## Install Docker-compose
##
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose