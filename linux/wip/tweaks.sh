#!/usr/bin/env bash

text() {
	tput rev
	printf " %s \n" "${1}"
	tput sgr0
}

function apply_apt {
	text 'apt'
	sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
	printf "Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;\nAcquire::Languages none;" | sudo tee /etc/apt/apt.conf.d/99-slim-apt
	sudo apt-get clean && sudo apt-get update
}

function apply_hostname {
	text 'hostname'
	tweak_hostname="a5"
	hostnamectl set-hostname a5
	[[ ! -f /etc/hosts.bak ]] && sudo cp -fv /etc/hosts /etc/hosts.bak
	printf "127.0.0.1 localhost\n127.0.1.1 %s\n" "${tweak_hostname}" | sudo tee /etc/hosts
}

function apply_locale {
	text 'locale'
	tweak_locale="en_US"
	sudo locale-gen "${tweak_locale}".UTF-8
	localectl set-locale LANG="${tweak_locale}".UTF-8
	localectl set-locale LANGUAGE="${tweak_locale}":en
}

function apply_time {
	text 'time'
	tweak_time="Asia/Kolkata"
	timedatectl set-timezone "${tweak_time}"
	timedatectl set-ntp true
	timedatectl set-local-rtc true
	timedatectl --adjust-system-clock
}

function apply_wireless {
	text 'wireless'
	tweak_wireless="2"
	sudo rm -fv "$(grep -lR "wifi.powersave" /etc/NetworkManager/conf.d || true | xargs)"
	printf "[connection]\nwifi.powersave = %s\n" "${tweak_wireless}" | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave.conf
}

function apply_zram {
	text 'zram'
	tweak_zram="4096"
	sudo apt-get install -y zram-config zram-tools
	[[ ! -f /etc/default/zramswap.bak ]] && sudo cp -fv /etc/default/zramswap /etc/default/zramswap.bak
	printf "ALGO=lz4\nSIZE=%s\nPRIORITY=200\n" "${tweak_zram}" | sudo tee /etc/default/zramswap
}

function main {
	apply_apt
	apply_hostname
	apply_locale
	apply_time
	apply_wireless
	apply_zram
}

# begin script from here
main "${@}"
