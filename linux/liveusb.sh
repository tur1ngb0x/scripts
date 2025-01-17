#!/usr/bin/env bash

function live_network {
	sudo bash -c 'sysctl -w net.ipv6.conf.all.disable_ipv6=1'
	sudo bash -c 'sysctl -w net.ipv6.conf.default.disable_ipv6=1'
	sudo bash -c 'sysctl -w net.ipv6.conf.lo.disable_ipv6=1'
	sudo bash -c 'systemctl restart NetworkManager'
	echo 'sleep 15'
	sleep 15
}

function live_host {
	sudo bash -c 'printf "127.0.0.1 localhost\n127.0.1.1 live\n" | tee /etc/hosts'
	sudo bash -c 'hostnamectl hostname live'
}

function live_time {
	timedatectl set-timezone Asia/Kolkata
	timedatectl set-local-rtc 1
	timedatectl set-ntp 1
	timedatectl --adjust-system-clock
}

function live_updates {
	sudo bash -c 'apt-get clean'
	sudo bash -c 'apt-get update'
	sudo bash -c 'apt-get install -y curl wget git micro nano vim xclip'
}

function live_git {
	mkdir -pv $HOME/src/
	git clone https://github.com/tur1ngb0x/dotfiles $HOME/src/dotfiles
	git clone https://github.com/tur1ngb0x/scripts $HOME/src/scripts
}

function live_brave {
	if [[ ! $(command -v brave-browser) ]]; then
		wget -4O '/tmp/brave.sh' 'https://dl.brave.com/install.sh'
		sh '/tmp/brave.sh'
	else
		echo "already installed at $(which brave-browser)"
	fi
}

function live_chrome {
	if [[ ! $(command -v google-chrome) ]]; then
		wget -4O '/tmp/chrome.deb' 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
		sudo bash -c 'apt-get install /tmp/chrome.deb'
	else
		echo "already installed at $(which google-chrome)"
	fi
}

function live_edge {
	if [[ ! $(command -v microsoft-edge) ]]; then
		wget -4O '/tmp/edge.deb' 'https://go.microsoft.com/fwlink?linkid=2149051'
		sudo bash -c 'apt-get install /tmp/edge.deb'
	else
		echo "already installed at $(which microsoft-edge)"
	fi
}

function main {
	live_network
	live_host
	live_time
	live_updates
	live_git
	live_brave
	live_chrome
	live_chrome
}

main "${@}"
