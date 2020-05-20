#!/bin/sh

if [ -z ${user+x} ]; then exit; else echo "user is set to ${user}"; fi
if [ -z ${pubkey+x} ]; then exit; else echo "pubkey is set to ${user}"; fi
if [ -f /etc/dnf/dnf.conf ]; then sudogroup="wheel"; else sudogroup="sudo"; fi


useradd -m -s /bin/bash -G $sudogroup $user
mkdir -p "/home/$user/.ssh"
chmod 700 /home/$user/.ssh
echo "$pubkey" > /home/$user/.ssh/authorized_keys
chmod 644 /home/$user/.ssh/authorized_keys
chown -R "${user}:${user}" /home/$user/.ssh
passwd -d $user
passwd -e $user 
