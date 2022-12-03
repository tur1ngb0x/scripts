#!/usr/bin/env bash

# blacklist nvidia modules
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

# remove nvidia devices
mkdir -pv /etc/udev/rules.d
cat << EOF | sudo tee /etc/udev/rules.d/novideo.rules
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
EOF

# print info
cat << EOF
# Remove intel driver (optional)
$ sudo apt-get purge xserver-xorg-video-intel
$ sudo pacman -Rns xf86-video-intel
$ sudo rm -fv /etc/X11/xorg.conf.d/20-intel.conf

# Remove nvidia driver (optional)
$ sudo apt-get purge ~nnvidia
$ sudo pacman -Rns nvidia nvidia-lts
$ sudo dnf remove akmod-nvidia* kmod-nvidia*
$ sudo rm -fv /etc/X11/xorg.conf.d/20-nvidia.conf
$ sudo rm -fv /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

# Set nvidia prime (mandatory)
$ sudo prime-select on-demand

# Disable gpu service (mandatory)
$ systemctl disable gpu-manager.service

# Update initramfs (mandatory)
$ sudo update-initramfs -u -k all -v		# debian/ubuntu
$ sudo dracut --force --regenerate-all		# fedora/rhel
$ sudo mkinitcpio -Pv						# arch/manjaro
EOF
