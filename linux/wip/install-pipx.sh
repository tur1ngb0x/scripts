#!/usr/bin/env bash

packages=(
	gallery-dl
	glances
	mycli
	ps_mem
	shellcheck-py
	speedtest-cli
	tldr
	yt-dlp
)

function install_pipx
{
	sudo apt-get install -y pipx || sudo dnf install -y pipx || sudo pacman -S --needed --noconfirm pipx
}

function install_packages
{
	for pkg in "${packages[@]}"; do
		pipx install --verbose "${pkg}"
	done
}

function prompt_user
{
	read -p "Do you want to continue? (Y): " -n 1 -r answer; echo
	if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
		exit
	fi
}

export USE_EMOJI="0"

install_pipx
prompt_user
install_packages

unset USE_EMOJI
