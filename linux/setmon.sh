#!/usr/bin/env bash

if [[ "${XDG_SESSION_TYPE}" != 'x11' ]]; then
	exit
fi

if [[ $(xrandr | grep -w 'connected' | grep -Ew '^eDP-*') ]]; then
	if [[ $(xrandr | grep -w 'connected' | grep -Ew '^HDMI-*') ]]; then
		xrandr --output 'eDP-1' --off
		xrandr --output 'HDMI-1' --auto --primary \
		--set 'aspect ratio' '16:9' \
		--set 'audio' 'off' \
		--set 'Broadcast RGB' 'Full' \
		--set 'Content Protection' 'Enabled' \
		--set 'Colorspace' 'Default' \
		--set 'HDCP Content Type' 'HDCP Type1' \
		--set 'non-desktop' '0' \
		--size '1920x1080' \
		--refresh '60' \
		--dpi '96'
	fi
fi
