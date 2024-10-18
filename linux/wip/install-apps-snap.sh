#!/usr/bin/env bash


sudo rm -fv /etc/apt/preferences.d/nosnap.pref
sudo apt-get install -y snapd
sudo dnf install -y snapd
sudo pacman -Syu snapd
sudo snap set system snapshots.automatic.retention=no
sudo snap refresh --hold
sudo snap refresh

LANG=C sudo snap list --all | while read -r name version revision tracking publisher notes; do if [[ "${notes}" = *disabled* ]]; then sudo snap remove --purge "${name}" --revision="${revision}"; fi; done; unset name version revision tracking publisher notes

pkgs_snap=(
	pieces-os
	pieces-for-developers
)

pkgs_snap_classic=(
	powershell
	alacritty
)

# install snaps
for pkg in "${pkgs_snap[@]}"; do
	sudo snap install "${pkg}"; done

for pkg in "${pkgs_snap_classic[@]}"; do
	sudo snap install "${pkg}" --classic; done

# snaps post install
if [[ $(snap list --all | grep -i 'bitwarden') ]]; then
	sudo sudo snap connect bitwarden:password-manager-service; fi

if [[ $(snap list --all | grep -i 'pieces-os') ]]; then
	sudo snap connect pieces-os:process-control :process-control; fi
