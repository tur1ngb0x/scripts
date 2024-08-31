#!/usr/bin/env bash

#codename="$(awk -F= '/UBUNTU_CODENAME/{print $2}' /etc/os-release)"
codename="$(source /etc/os-release; echo "${UBUNTU_CODENAME}")"
readonly codename

function apt_brave {
	sudo apt-get install -y curl
	sudo curl -Lo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	cat <<-EOF | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main
	EOF
	sudo apt-get update
	sudo apt-get install -y brave-browser
}

function apt_chrome {
	sudo apt-get install -y wget
	wget -4O /tmp/chrome.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	sudo apt-get install -y /tmp/chrome.deb
}

function apt_docker {
	sudo apt-get install -y curl wget
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get purge --autoremove "${pkg}"; done
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	cat <<-EOF | sudo tee /etc/apt/sources.list.d/docker.list
	deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu/ ${codename} stable
	EOF
	sudo apt-get update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd -f docker && sudo usermod -aG docker "${USER}"
}

function apt_spotify {
	sudo apt-get install -y curl
	curl -L https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	cat <<-EOF | sudo tee /etc/apt/sources.list.d/spotify.list
	deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] http://repository.spotify.com stable non-free
	EOF
	sudo apt-get update
	sudo apt-get install -y spotify-client
}

function apt_vscode {
	sudo apt-get install -y wget
	wget -4O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
	sudo apt-get install -y /tmp/code.deb
}

# begin script from here
apt_brave
apt_chrome
apt_vscode
apt_docker
