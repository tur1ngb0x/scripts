#!/usr/bin/env bash

set -euxo pipefail

if [[ "${XDG_SESSION_TYPE}" != "x11" ]]; then
    echo "Current session type is: ${XDG_SESSION_TYPE}"
    echo "This script is designed for X11 sessions only."
    exit
fi

command -p xset +dpms dpms 0 0 0

command -p xset dpms force on

command -p i3lock \
        --color 000000 \
        --image ~/src/dotfiles/linux/user/.local/share/backgrounds/macos.png \
        --pointer default \
        --ignore-empty-password \
        --show-failed-attempts \
        --clock \
        --time-str '%H:%M' \
        --time-size 72 \
        --time-color FFFFFF \
        --date-str '%Y %B %d %A' \
        --date-size 24 \
        --date-color ffffff

command -p sleep 1

command -p xset dpms force off
