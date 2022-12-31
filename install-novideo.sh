#!/usr/bin/env bash

echo() { printf '\n\n\n\n\n\n\n%s\n' "${1}"; }

echo '* Removing legacy intel driver...'
sudo apt-get purge -y xserver-xorg-video-intel
sudo pacman -Rns xf86-video-intel
sudo rm -fv /etc/X11/xorg.conf.d/20-intel.conf
sudo rm -fv /etc/X11/xorg.conf.d/20-nvidia.conf
sudo rm -fv /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

echo '* Removing nvidia drivers...'
sudo apt-get purge -y ~nnvidia
sudo pacman -Rns nvidia nvidia-lts

echo '* Disabling gpu manager service...'
sudo systemctl disable gpu-manager.service

echo '* Blacklisting nvidia modules via modprobe...'
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

echo '* Removing nvidia devices via udev...'
sudo mkdir -p /etc/udev/rules.d
cat << EOF | sudo tee /etc/udev/rules.d/novideo.rules
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
EOF

echo '* Regenerating initramfs...'
sudo update-initramfs -u -k all || sudo dracut --force --regenerate-all || sudo mkinitcpio -P
