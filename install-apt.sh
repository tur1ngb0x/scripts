#!/usr/bin/env bash

# packages
sudo apt-get install --install-recommends -y apt-transport-https ca-certificates curl git gnupg lsb-release wget
sudo apt-get install --install-recommends -y android-sdk-platform-tools ddcutil libfuse2
sudo apt-get install --install-recommends -y flatpak snapd synaptic
sudo apt-get install --install-recommends -y atool dos2unix p7zip-full p7zip-rar tree xclip
sudo apt-get install --install-recommends -y build-essential python3-dev python3-pip python3-venv python-is-python3

# mysql
wget -O /tmp/mysql.deb 'https://repo.mysql.com/mysql-apt-config_0.8.24-1_all.deb'
sudo apt-get update && sudo apt-get install --install-recommends -y /tmp/mysql.deb
sudo apt-key export 3A79BD29 | sudo gpg --dearmour -o /usr/share/keyrings/mysql.gpg && sudo apt-key del 3A79BD29
cat << EOF | sudo tee /etc/apt/sources.list.d/mysql.list
deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu/ jammy mysql-apt-config
deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu/ jammy mysql-8.0
deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu/ jammy mysql-tools
deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu/ jammy mysql-tools-preview
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y mysql-server mysql-workbench-community

# chrome
wget -O /tmp/chrome.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
sudo apt-get install --install-recommends -y /tmp/chrome.deb

# code
wget -O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt-get install --install-recommends -y /tmp/code.deb

# docker
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd -f docker && sudo usermod -aG docker "${USER}"

# virtmanager
sudo apt-get install --install-recommends -y virt-manager
sudo groupadd -f libvirt && sudo usermod -aG libvirt "${USER}"
sudo groupadd -f kvm && sudo usermod -aG kvm "${USER}"
cat << EOF | sudo tee -a /etc/libvirt/libvirtd.conf
unix_sock_group = libvirt
unix_sock_rw_perms = 0770
EOF
cat << EOF | sudo tee -a /etc/libvirt/libvirtd.conf
user = ${USER}
group = ${USER}
EOF

# virtualbox
curl -fsSL 'https://virtualbox.org/download/oracle_vbox_2016.asc' | sudo gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/virtualbox.list
deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y virtualbox-7.0 zathura- zathura-pdf-poppler-
sudo groupadd -f vboxusers && sudo usermod -aG vboxusers "${USER}"
sudo groupadd -f vboxsf && sudo usermod -aG vboxsf "${USER}"

# i3
#curl -fsSL 'https://baltocdn.com/i3-window-manager/signing.asc' | sudo gpg --dearmor -o /usr/share/keyrings/baltocdn-i3.gpg
#cat << EOF | sudo tee /etc/apt/sources.list.d/baltocdn-i3.list
#deb [arch=amd64 signed-by=/usr/share/keyrings/baltocdn-i3.gpg] https://baltocdn.com/i3-window-manager/i3/i3-autobuild-ubuntu all main
#EOF
#sudo apt-get update && sudo apt-get install --install-recommends -y i3

# git
sudo add-apt-repository -yn ppa:git-core/ppa
sudo apt-get update && sudo apt-get install --install-recommends -y git
sudo apt-get install --install-recommends -y build-essential libsecret-1-0 libsecret-1-dev
sudo make -C /usr/share/doc/git/contrib/credential/libsecret
