#!/usr/bin/env bash

SCREENCLIP_DIR="${HOME}/Pictures/Screenshots"
SCREENCLIP_FILE="${SCREENCLIP_DIR}/screenclip-$(date +'%Y%m%d-%H%M%S').png"

# create screenshot directory
if [[ ! -d "${SCREENCLIP_DIR}" ]]; then
	mkdir -pv "${SCREENCLIP_DIR}"
fi

# capture screenshot
if [[ $(command -pv gnome-screenshot) ]]; then
	gnome-screenshot --area --clipboard --file="${SCREENCLIP_FILE}"
elif [[ $(command -pv xfce4-screenshooter) ]]; then
	xfce4-screenshooter --region --clipboard --save="${SCREENCLIP_FILE}"
elif [[ $(command -pv spectacle) ]]; then
	spectacle --background --nonotify --region --copy-image --output="${SCREENCLIP_FILE}"
elif [[ $(command -pv scrot) ]]; then
	scrot --quality 100 --select --freeze --file="${SCREENCLIP_FILE}"
elif [[ $(command -pv notify-send) ]]; then
	notify-send 'screenshot tool not found'
else
	tput rev; tput bold; echo ' screenshot tool not found ' ; tput sgr0 && exit
fi
