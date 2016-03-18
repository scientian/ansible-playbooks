#!/bin/sh

set -e

if [ $# -lt 1 ]; then
        echo "Usage: sudo ./configure_docker0.sh <ip/CIDR>"
        echo "   examples: "
        echo "        ./configure_docker0.sh 10.200.0.57/16"
        echo "        ./configure_docker0.sh 172.31.0.21/16"
        echo "        ./configure_docker0.sh 192.168.254.13/24"
        echo " "
        echo " NOTE: You should stop Docker before running this script."
        echo "       When you restart it, Docker will use the new IP."
        exit 2
fi

NEW_IP="$1"

echo "Removing old docker0 network(s)"
NETWORKS=$(ip addr list docker0 | grep "inet " | cut -d" " -f6)
for NET in $NETWORKS; do
        echo "  $NET"
        ip addr del $NET dev docker0
done

echo "Adding new docker0 network"
ip addr add $NEW_IP dev docker0

echo "Removing old iptables rules"
iptables -t nat -F POSTROUTING
iptables -F DOCKER

echo " "
echo "Update /etc/default/docker so the changes persist across reboots"
P=DOCKER_OPTS="--bip=${NEW_IP}";

sed -i -e "\|$P|h; \${x;s|$P||;{g;t};a\\" -e "$P" -e "}" /etc/default/docker
