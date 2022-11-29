#!/usr/bin/env bash

mkdir -pv /etc/modprobe.d
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

mkdir -pv /etc/udev/rules.d
cat << EOF | sudo tee /etc/udev/rules.d/novideo.rules
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
EOF

cat << EOF
# Remove intel driver
$ sudo apt-get purge xserver-xorg-video-intel
$ sudo pacman -Rns xf86-video-intel
$ sudo rm -fv /etc/X11/xorg.conf.d/20-intel.conf

# Remove nvidia driver
$ sudo apt-get purge ~nnvidia

# Set nvidia prime
$ sudo prime-select on-demand

# Disable gpu service
$ systemctl disable gpu-manager.service

# Update initramfs
$ sudo update-initramfs -u -k all -v
$ sudo dracut --force --regenerate-all
$ sudo mkinitcpio -Pv
EOF
