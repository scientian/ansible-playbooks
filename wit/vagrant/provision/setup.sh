#!/bin/bash

set -e

# Switch to UMD's Ubuntu mirror to avoid FiOS throttling
sed -i -e 's/archive\.ubuntu\.com/mirror.umd.edu/g' /etc/apt/sources.list

# Install the basics
apt-get update
apt-get install -y \
    linux-headers-$(uname -r) linux-image-extra-$(uname -r) \
    git pcregrep pv htop btrfs-tools \
    curl wget parallel pigz \
    php5-cli php5-json php5-curl php5-mcrypt unzip \

#apt-get install -y  linux-generic-lts-vivid linux-headers-generic-lts-vivid linux-image-extra-virtual-lts-vivid

# Setup second disk as BTRFS docker storage
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 2048 100%
mkfs.btrfs --label docker_storage /dev/sdb1
mkdir /var/lib/docker
echo LABEL=docker_storage /var/lib/docker btrfs defaults 0 0 >> /etc/fstab
mount /dev/sdb1

# Download and install Docker
wget -qO- https://get.docker.com/ | sh
usermod -aG docker vagrant

# Fix the network interface
wget https://gist.githubusercontent.com/kamermans/94b1c41086de0204750b/raw/configure_docker0.sh
chmod +x configure_docker0.sh
./configure_docker0.sh 192.168.254.1/24
echo 'DOCKER_OPTS="--bip=192.168.254.1/24"' >> /etc/default/docker
service docker restart

# Install Docker Compose
curl -sSL https://github.com/docker/compose/releases/download/1.3.1/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -sSL https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

# Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Improve Bash
curl -sSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > /home/vagrant/.git-prompt.sh
curl -sSL https://gist.githubusercontent.com/kamermans/84d2de998c3804b98517/raw/.bash_git.sh > /home/vagrant/.bash_git.sh
chown vagrant: /home/vagrant/.*.sh
echo ". ~/.bash_git.sh" >> /home/vagrant/.bashrc
sed -i -e '/^#force_color_prompt/s/^#//g' /home/vagrant/.bashrc
