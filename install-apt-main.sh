#!/usr/bin/env bash

# essentials
sudo apt-get install --install-recommends -y apt-transport-https ca-certificates curl git gnupg lsb-release wget

# drivers
sudo apt-get install --install-recommends -y android-sdk-platform-tools ddcutil libfuse2

# apps stores
sudo apt-get install --install-recommends -y flatpak snapd synaptic

# programming
sudo apt-get install --install-recommends -y build-essential libsecret-1-0 libsecret-1-dev python3-dev python3-pip python3-venv python-is-python3
sudo make -C /usr/share/doc/git/contrib/credential/libsecret

# apps cli
sudo apt-get install --install-recommends -y atool dos2unix p7zip-full p7zip-rar tree xclip

# apps gui
sudo apt-get install --install-recommends -y gparted

# virtualization
sudo apt-get install --install-recommends -y virt-manager
sudo usermod -aG kvm,libvirt "${USER}"
printf "\nunix_sock_group = libvirt\nunix_sock_rw_perms = 0770\n" | sudo tee -a /etc/libvirt/libvirtd.conf
printf "\nuser = ${USER}\ngroup = ${USER}\n" | sudo tee -a /etc/libvirt/qemu.conf
