#!/usr/bin/env bash

[[ ! -d "${HOME}/Pictures/Screenshots" ]] && mkdir -p "${HOME}/Pictures/Screenshots"

gnome-screenshot --area --clipboard --file="${HOME}/Pictures/Screenshots/screenclip_$(date +'%Y%m%d-%H%M%S').png"
