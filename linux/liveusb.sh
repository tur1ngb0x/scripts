#!/usr/bin/env bash

# disable ipv6
sudo bash -c 'sysctl -w net.ipv6.conf.all.disable_ipv6=1'
sudo bash -c 'sysctl -w net.ipv6.conf.default.disable_ipv6=1'
sudo bash -c 'sysctl -w net.ipv6.conf.lo.disable_ipv6=1'
sudo bash -c 'systemctl restart NetworkManager'

# hostname
sudo bash -c 'printf "127.0.0.1 localhost\n127.0.1.1 live\n" | tee /etc/hosts'
sudo bash -c 'hostnamectl hostname live'

# time
timedatectl set-timezone Asia/Kolkata
timedatectl set-local-rtc 1
timedatectl set-ntp 1
timedatectl --adjust-system-clock

# updates
sudo bash -c 'apt-get clean'
sudo bash -c 'apt-get update
sudo bashd -c 'apt-get install -y curl wget git micro nano vim xclip'

# git
mkdir -pv $HOME/src/
git clone https://github.com/tur1ngb0x/dotfiles $HOME/src/dotfiles
git clone https://github.com/tur1ngb0x/scripts $HOME/src/scripts

# brave
wget -4O '/tmp/brave.sh' 'https://dl.brave.com/install.sh
sh '/tmp/brave.sh'

# chrome
wget -4O '/tmp/chrome.deb' 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
sudo bash -c 'apt-get install /tmp/chrome.deb'

# edge
wget -4O '/tmp/edge.deb' 'https://go.microsoft.com/fwlink?linkid=2149051'
sudo bash -c 'apt-get install /tmp/edge.deb'
