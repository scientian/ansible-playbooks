#!/usr/bin/env sh

HOSTNAME=$1
FQDN=$2
DOMAIN="scientiamobile.local"

if [ "$HOSTNAME" = "" ] || [ "$HOSTNAME" = "$FQDN" ]; then
	FQDN="$HOSTNAME.$DOMAIN"
	echo "Setting FQDN: $FQDN"
	echo $FQDN > /etc/hostname
fi

if [ $(grep -c "$FQDN" /etc/hosts) = "0" ]; then
	echo "Adding hostname to /etc/hosts"
	sed -i -r "s/^127\.0\.1\.1.*$/127.0.1.1\t$HOSTNAME $FQDN # Added by Ansible/" /etc/hosts
fi
