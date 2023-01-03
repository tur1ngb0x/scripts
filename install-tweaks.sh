#!/usr/bin/env bash

# hostname
name="starlabs"

# kernel parameters
flags="ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer"

# swappiness
swap="10"

# locale
lang="en_IN.UTF-8"

# keyboard layout
kbl="us"

# timezone
tz="Asia/Kolkata"

# wireless power mode
wpow="2"

echo() { printf '\n\n\n\n\n\n\n%s\n' "${1}"; }

echo 'APT'
printf 'Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;\nAcquire::Languages none;\n' | sudo tee /etc/apt/apt.conf.d/99-slimapt
sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources

echo 'GRUB'
printf "GRUB_CMDLINE_LINUX_DEFAULT=\"${flags}\"\nGRUB_DISTRIBUTOR=Ubuntu\n" | sudo tee /etc/default/grub
sudo update-grub

echo 'KERNELSTUB'
sudo kernelstub -vv -o "${flags}"

echo 'HOSTNAME'
hostnamectl set-hostname "${name}"
printf "127.0.0.1\tlocalhost\n127.0.1.1\t${name}\n" | sudo tee /etc/hosts

echo 'LOCALE'
localectl set-locale LANG="${lang}"
localectl set-keymap "${kbl}"
sudo locale-gen "${lang}"
sudo update-locale "${lang}"

echo 'NOVIDEO'
sudo systemctl disable gpu-manager.service
sudo mkdir -p /etc/modprobe.d
cat << EOF | sudo tee /etc/modprobe.d/novideo.conf
alias nouveau off
alias nvidia off
alias nvidia_drm off
alias nvidia_modeset off
alias nvidia_uvm off
blacklist nouveau
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
EOF
sudo mkdir -p /etc/udev/rules.d
cat << EOF | sudo tee /etc/udev/rules.d/novideo.rules
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
EOF
sudo update-initramfs -u -k all || sudo dracut --force --regenerate-all || sudo mkinitcpio -P

echo 'SWAP'
printf "vm.swappiness = ${swap}\n" | sudo tee /etc/sysctl.d/99-swappiness.conf

echo 'TIME'
timedatectl set-timezone "${tz}"
timedatectl set-ntp true
timedatectl set-local-rtc true
timedatectl --adjust-system-clock

echo 'WIRELESS'
sudo rm -fv /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
printf "[connection]\nwifi.powersave = ${wpow}\n" | sudo tee /etc/NetworkManager/conf.d/99-wifi-power.conf
