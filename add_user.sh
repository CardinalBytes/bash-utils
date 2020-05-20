#!/bin/sh

if [ -z "$NEW_USER" ]; then
	return
else
	user="$NEW_USER"
	printf 'user is set to %s' "$user"
fi

if [ -z "$SUDOGROUP" ]; then
	sudogroup="$SUDOGROUP"
else 
	if [ -f "/etc/dnf/dnf.conf" ]; then
		printf "found dnf configuration file assuming RHEL default of \'wheel\'"
		sudogroup="wheel"
	fi;
	if [ -d "/etc/apt/apt.conf/" ]; then
		printf "found apt files assuming debian derived distro and using default of \'sudo\' group"
		sudogroup="sudo"
	fi
fi


useradd -m -s /bin/bash -G "$sudogroup" "$user"
if [ -z "$PUBKEY" ]; then 
	printf 'no pubkey given, ssh access will not be setup for the user %s' "$user"
else 
	pubkey="$PUBKEY"
	echo "pubkey is set for ${user} and ssh access will be setup"
	mkdir -p "/home/$user/.ssh"
	chmod 700 "/home/$user/.ssh"
	echo "$pubkey" > "/home/$user/.ssh/authorized_keys"
	chmod 644 "/home/$user/.ssh/authorized_keys"
	chown -R "${user}:${user}" "/home/$user/.ssh"
fi
passwd -d "$user"
passwd -e "$user"
