#!/usr/bin/env bash

# essentials
sudo apt-get install --install-recommends -y curl git wget

# drivers
sudo apt-get install --install-recommends -y android-sdk-platform-tools ddcutil libfuse2
sudo mkdir -pv /etc/modules-load.d
printf 'i2c-dev\n' | sudo tee /etc/modules-load.d/i2c-dev.conf
sudo groupadd -f i2c && sudo usermod -aG i2c "${USER}"

# appstores
sudo rm -fv /etc/apt/preferences.d/nosnap.pref
sudo apt-get install --install-recommends -y flatpak snapd synaptic

# programming
sudo apt-get install --install-recommends -y bash-completion build-essential libsecret-1-0 libsecret-1-dev python3-dev python3-pip python3-venv python-is-python3
sudo make -C /usr/share/doc/git/contrib/credential/libsecret
sudo mv -fv /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret /usr/local/bin/git-credential-libsecret

# apps
sudo apt-get install --install-recommends -y ffmpeg gparted lm-sensors mediainfo net-tools

# tools
sudo apt-get install --install-recommends -y atool dos2unix p7zip-full p7zip-rar tree vim xclip

# virtualization
sudo apt-get install --install-recommends -y virt-manager
sudo groupadd -f kvm && sudo usermod -aG kvm "${USER}"
sudo groupadd -f libvirt && sudo usermod -aG libvirt "${USER}"

# libvirtd
cat << EOF | sudo tee /etc/libvirt/libvirtd.conf
auth_unix_ro = "none"
auth_unix_rw = "none"
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
EOF

# qemu
cat << EOF | sudo tee /etc/libvirt/qemu.conf
swtpm_user = "swtpm"
swtpm_group = "swtpm"
user = "${USER}"
group = "${USER}"
EOF
