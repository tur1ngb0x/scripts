#!/usr/bin/env bash

set -x

if [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
	if [[ -f /usr/bin/xrandr ]]; then
		if xrandr | grep -E '^(eDP-.*|HDMI-.*) connected'; then
			xrandr --output 'eDP-1' --off
			xrandr --output 'HDMI-1' --auto --primary \
				--set 'aspect ratio' '16:9' \
				--set 'audio' 'on' \
				--set 'Broadcast RGB' 'Full' \
				--set 'Content Protection' 'Enabled' \
				--set 'Colorspace' 'Default' \
				--set 'HDCP Content Type' 'HDCP Type1' \
				--set 'non-desktop' '0' \
				--size '1920x1080' \
				--refresh '60' \
				--dpi '96'
		fi
	else
		printf "xrandr not found\n* apt install x11-xserver-utils\n* dnf install xrandr\n* pacman -S xorg-xrandr\n"
	fi
else
	echo '${XDG_SESSION_TYPE} is not x11.'
fi

set +x
