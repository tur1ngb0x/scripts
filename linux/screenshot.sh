#!/usr/bin/env bash

if [[ "${XDG_SESSION_TYPE}" != "x11" ]]; then
    echo "Current session type is: ${XDG_SESSION_TYPE}"
    echo "This script is designed for X11 sessions only."
    exit
fi

for t in gnome-screenshot xfce4-screenshooter spectacle scrot; do
    if command -v "${t}" &>/dev/null; then
        tool="${t}"
        break
    fi
done

if [[ -z "${tool}" ]]; then
    echo "No screenshot tool found."
    echo "Install: gnome-screenshot xfce4-screenshooter spectacle scrot"
    exit
fi

mkdir -p "${HOME}/Pictures/screenshot.sh"

file="${HOME}/Pictures/screenshot.sh/ss-$(date +%Y%m%d-%H%M%S).png"

case ${tool} in
gnome-screenshot)    gnome-screenshot --area --clipboard --file "${file}" ;;
xfce4-screenshooter) xfce4-screenshooter --region --clipboard --save "${file}" ;;
spectacle)           spectacle -b -n -r -c -o "${file}" ;;
scrot)               scrot --compression 0 --quality 100 --select --freeze --file "${file}" ;;
esac
