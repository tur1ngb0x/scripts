#!/usr/bin/env bash

sudo apt install samba || sudo dnf install samba || sudo pacman -S samba

sudo groupadd -f sambashare; sudo usermod -aG sambashare "${USER}"

sudo smbpasswd -a "${USER}"; sudo smbpasswd -e "${USER}"

sudo cp -fv /etc/samba/smb.conf /etc/samba/smb.conf.bak

cat << EOF | sudo tee /etc/samba/smb.conf; clear; testparm -s
[global]
# server
server role = standalone server
server string = $(hostnamectl hostname)-samba-server
workgroup = WORKGROUP
# security
client max protocol = SMB3
client min protocol = SMB3
client smb encrypt = required
# logging
log file = /var/log/samba/log.%m
max log size = 1024

[$(hostnamectl hostname)-samba-server]
comment = $(hostnamectl hostname)-samba-server
path = /home/${USER}
force group = ${USER}
force user = ${USER}
valid users = ${USER}
writable = yes
fstype = Samba
EOF

sudo systemctl enable --now smbd.service nmbd.service || sudo systemctl enable --now smb.service nmb.service

sudo systemctl --no-pager status smbd.service nmbd.service || sudo systemctl --no-pager status smb.service nmb.service
