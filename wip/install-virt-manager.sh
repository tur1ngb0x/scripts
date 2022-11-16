#!/usr/bin/env bash

sudo apt-get install --install-recommends -y virt-manager
sudo usermod -aG libvirt,kvm "${USER}" && groups "${USER}"
printf "\nunix_sock_group = libvirt\nunix_sock_rw_perms = 0770\n" | sudo tee -a /etc/libvirt/libvirtd.conf
printf "\nuser = ${USER}\ngroup = ${USER}\n" | sudo tee -a /etc/libvirt/qemu.conf
