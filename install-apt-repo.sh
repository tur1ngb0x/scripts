#!/usr/bin/env bash

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

# docker
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd -f docker && sudo usermod -aG docker "${USER}"

# chrome
wget -O /tmp/chrome.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
sudo apt-get install --install-recommends -y /tmp/chrome.deb

# code
wget -O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt-get install --install-recommends -y /tmp/code.deb
code --install-extension formulahendry.code-runner
code --install-extension piousdeer.adwaita-theme
code --install-extension yzane.markdown-pdf

# virtualbox
curl -fsSL 'https://virtualbox.org/download/oracle_vbox_2016.asc' | sudo gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/virtualbox.list
deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y virtualbox-7.0 zathura- zathura-pdf-poppler-
sudo groupadd -f vboxusers && sudo usermod -aG vboxusers "${USER}"
sudo groupadd -f vboxsf && sudo usermod -aG vboxsf "${USER}"

# i3
curl -fsSL 'https://baltocdn.com/i3-window-manager/signing.asc' | sudo gpg --dearmor -o /usr/share/keyrings/baltocdn-i3.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/baltocdn-i3.list
deb [arch=amd64 signed-by=/usr/share/keyrings/baltocdn-i3.gpg] https://baltocdn.com/i3-window-manager/i3/i3-autobuild-ubuntu all main
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y i3
