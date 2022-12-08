#!/usr/bin/env bash

# load zram module at startup
sudo mkdir -pv /etc/modules-load.d
printf 'zram\n' | sudo tee /etc/modules-load.d/zram.conf

# set zram device limit to 1
sudo mkdir -pv /etc/modprobe.d
printf 'options zram num_devices=1\n' | sudo tee /etc/modprobe.d/zram.conf

# create zram udev rule with 4096M ~ 4GB size
mkdir -pv /etc/udev/rules.d
printf 'KERNEL=="zram0", ATTR{disksize}="4096M", ATTR{comp_algorithm}="lz4", RUN="/usr/sbin/mkswap /dev/zram0", TAG+="systemd"\n' | sudo tee /etc/udev/rules.d/99-zram.rules

# add zram entry to fstab
printf '\n\n/dev/zram0 none swap defaults,pri=100 0 0\n\n' | sudo tee -a /etc/fstab

# reboot machine
# reboot

# check zram
# cat /proc/swaps
