#!/usr/bin/env bash

#codename="$(awk -F= '/UBUNTU_CODENAME/{print $2}' /etc/os-release)"
codename="$(source /etc/os-release; echo "${UBUNTU_CODENAME}")"
readonly codename

function apt_chrome {
	wget -4O /tmp/chrome.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	sudo apt install -y /tmp/chrome.deb
}

function apt_vcode {
	wget -4O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
	sudo apt install -y /tmp/code.deb
}

function apt_docker {
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get purge --autoremove "${pkg}"; done
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	cat <<-EOF | sudo tee /etc/apt/sources.list.d/docker.list
	deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu/ ${codename} stable
	EOF
	sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd -f docker && sudo usermod -aG docker "${USER}"
}

# begin script from here
apt_chrome
apt_vscode
apt_docker
