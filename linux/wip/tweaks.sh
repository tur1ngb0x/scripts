#!/usr/bin/env bash

[[ $(id -u) -eq 0 ]] && echo "Run the script as a non-root user. Exiting." && exit
cdir=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
echo() { tput bold && tput setaf 4 && printf "\\n\\n\\n%s\\n" "${1}" && tput sgr0; }

echo '[SET] - apt'
printf 'Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;\\nAcquire::Languages none;\\n' | sudo tee /etc/apt/apt.conf.d/99-slim-apt
sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
sudo apt-get clean && sudo apt-get update

echo '[SET] hostname'
hostnamectl set-hostname a5
printf '127.0.0.1\\tlocalhost\\n127.0.1.1\\ta5\\n' | sudo tee /etc/hosts

echo '[SET] locale'
localectl set-locale LANG=en_IN.UTF-8
localectl set-locale LANGUAGE=en_IN:en
sudo locale-gen en_IN.UTF-8

echo '[SET] time'
timedatectl set-timezone Asia/Kolkata
timedatectl set-ntp true
timedatectl set-local-rtc true
timedatectl --adjust-system-clock

# echo '[SET] swap'
# printf 'vm.swappiness = 1\\n' | sudo tee /etc/sysctl.d/99-vm-swappiness.conf

echo '[SET] wifi'
sudo rm -fv /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
printf "[connection]\\nwifi.powersave = 2\\n" | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave.conf

echo '[SET] - zram'
sudo apt-get install -y zram-config zram-tools
