#!/usr/bin/env bash

# check for gnome-screenshot
[[ ! -f /usr/bin/gnome-screenshot ]] && notify-send 'gnome-screenshot is not installed' && exit

# check for screenshot directory
[[ ! -d "${HOME}/Pictures/Screenshots" ]] && mkdir -p "${HOME}/Pictures/Screenshots"

# take area screenshot, copy to clipboard and save to file
gnome-screenshot --area --clipboard --file="${HOME}/Pictures/Screenshots/screenclip_$(date +'%Y%m%d-%H%M%S').png"

