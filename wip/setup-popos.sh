#!/usr/bin/env bash

# apt settings
#sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
#sudo sed -i 's/Types: deb deb-src/Types: deb/' /etc/apt/sources.list.d/pop-os-release.sources
#sudo sed -i 's/Types: deb deb-src/Types: deb/' /etc/apt/sources.list.d/system.sources

# bloatware
bloat_repo_ubuntu=(
	baobab
	eog
	evince
	geary
	gedit
	gnome-calculator
	gnome-calendar
	gnome-contacts
	gnome-font-viewer
	gnome-weather
	gucharmap
	libreoffice*
	seahorse
	simple-scan
	totem*
)

bloat_repo_pop=(
	appstream
	com.github.donadigo.eddy
	firefox
	hidpi-daemon
	pop-shop
	popsicle-gtk
	system76-scheduler
)

printf "\nUbuntu Bloatware: \n" && for pkg in "${bloat_repo_ubuntu[@]}"; do printf "${pkg} "; done && printf "\n"
printf "\nPopOS Bloatware: \n" && for pkg in "${bloat_repo_pop[@]}"; do printf "${pkg} "; done && printf "\n"
