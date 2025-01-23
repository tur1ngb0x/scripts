#!/usr/bin/env bash

# variables
rootdir="${HOME}/Pictures/screenshots"
timestamp="$(date +'%Y%m%d-%H%M%S')"
file="${rootdir}/screenshot-${timestamp}.png"
log="/tmp/screenshot-$(date +'%Y%m%d-%H%M%S').log"

# create screenshot directory
if [[ ! -d "${rootdir}" ]]; then
	mkdir -pv "${rootdir}" &>/dev/null
fi

# capture screenshot
if [[ $(command -pv gnome-screenshot) ]]; then
	gnome-screenshot --area --clipboard --file="${file}" &>"${log}"
elif [[ $(command -pv xfce4-screenshooter) ]]; then
	xfce4-screenshooter --region --clipboard --save="${file}" &>"${log}"
elif [[ $(command -pv spectacle) ]]; then
	spectacle --background --nonotify --region --copy-image --output="${file}" &>"${log}"
elif [[ $(command -pv scrot) ]]; then
	scrot --quality 100 --select --freeze --file="${file}" &>"${log}"
elif [[ $(command -pv notify-send) ]]; then
	notify-send 'screenshot app not found'
else
	echo 'screenshot app not found'
fi

echo -e "file\t${file}"
echo -e "log\t${log}"

# xdg-open "${output_video}"
# xdg-open "${output_log}"

unset rootdir timestamp file log
