#!/usr/bin/env bash

text(){ tput rev; printf " %s \n" "${1}"; tput sgr0; }

function apply_apt {
	text 'apt'
	sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
	printf "Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;\nAcquire::Languages none;" | sudo tee /etc/apt/apt.conf.d/99-slim-apt
	sudo apt-get clean && sudo apt-get update
}

function apply_hostname {
	text 'hostname'
	hostnamectl set-hostname a5
	[[ ! -f /etc/hosts.bak ]] && sudo cp -fv /etc/hosts /etc/hosts.bak
	printf "127.0.0.1 localhost\n127.0.1.1 a5\n" | sudo tee /etc/hosts
}

function apply_locale {
	text 'locale'
	sudo locale-gen en_IN.UTF-8
	localectl set-locale LANG=en_IN.UTF-8
	localectl set-locale LANGUAGE=en_IN:en
}

function apply_swap {
	text 'swap'
	printf 'vm.swappiness = 1\\n' | sudo tee /etc/sysctl.d/99-vm-swappiness.conf
}

function apply_time {
	text 'time'
	timedatectl set-timezone Asia/Kolkata
	timedatectl set-ntp true
	timedatectl set-local-rtc true
	timedatectl --adjust-system-clock
}

function apply_wireless {
	text 'wireless'
	sudo rm -fv /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
	printf "[connection]\nwifi.powersave = 2\n" | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave.conf
}

function apply_zram {
	text 'zram'
	sudo apt-get install -y zram-config zram-tools
	[[ ! -f /etc/default/zramswap.bak ]] && sudo cp -fv /etc/default/zramswap /etc/default/zramswap.bak
	printf "ALGO=lz4\nPERCENT=40\nSIZE=4096\nPRIORITY=180\n" | sudo tee /etc/default/zramswap
}

function main {
	apply_apt
	apply_hostname
	apply_locale
	apply_swap
	apply_time
	apply_wireless
	apply_zram
}

# begin script from here
main "${@}"
