#!/bin/bash

#set -e

echo " " 
if [ "$(id -u)" != "0" ]; then
	echo "you are not root"
	echo "Usage: sudo ./install_docker.sh"
	exit 2
fi

if ! hash docker 2>/dev/null ; then
	echo "docker-engine is not installed, installing docker-engine..."
	apt-get update > /dev/null
	apt-get autoremove -y > /dev/null
	apt-get install -y apt-transport-https ca-certificates > /dev/null
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D > /dev/null
	rm -rf /etc/apt/sources.list.d/docker.list
	echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
	apt-get update > /dev/null
	apt-get purge lxc-docker > /dev/null
	apt-get install -y linux-image-extra-$(uname -r) > /dev/null
	apt-get install -y apparmor > /dev/null
	echo DOCKER_OPTS=\"--bip=192.168.254.1/24 --default-ulimit=\'memlock=100000\'\" > /etc/default/docker
	apt-get install -y -o Dpkg::Options::="--force-confold" docker-engine > /dev/null
	service docker start
	docker -v

else
	echo "docker-engine is already installed."
	docker -v
fi

if ! hash docker-compose ; then
	echo "docker-compose is not installed, installing docker-compose..."
	curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose --version


else
	echo "docker-compose is already installed."
	docker-compose --version
fi

echo " "
exit 0
