#!/usr/bin/env bash

ppa_git() {
	sudo apt-add-repository -yn ppa:git-core/ppa
	sudo apt-get update && sudo apt-get install --install-recommends -y git
}

ppa_system76() {
	printf 'Package: *\nPin: release o=LP-PPA-system76-dev-stable\nPin-Priority: -9999\n' | sudo tee /etc/apt/preferences.d/system76-dev-stable.pref
	printf 'Package: system76-power\nPin: release o=LP-PPA-system76-dev-stable\nPin-Priority: 9999\n' | sudo tee /etc/apt/preferences.d/system76-power.pref
	sudo apt-add-repository -yn ppa:system76-dev/stable
	sudo apt-get update && sudo apt-get install system76-power
	sudo groupadd -f adm && sudo usermod -aG adm "${USER}"
	sudo system76-power graphics integrated
	# reboot
	# sudo system76-power graphics power off
	# sudo system76-power profile performance
	# sudo system76-power profile performance
}

ppa_razer() {
	sudo apt-add-repository -yn ppa:openrazer/stable
	sudo apt-add-repository -yn ppa:polychromatic/stable
	sudo apt-get update && sudo apt-get install openrazer-meta polychromatic
	sudo groupadd -f plugdev && sudo usermod -aG plugdev "${USER}"
}

# begin script from here
ppa_git

# rarely used
# ppa_system76
# ppa_razer
