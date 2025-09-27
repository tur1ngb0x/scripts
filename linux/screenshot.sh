#!/usr/bin/env bash

for t in gnome-screenshot xfce4-screenshooter spectacle scrot; do command -v "$t" &>/dev/null && tool=$t && break; done

[ -z "$tool" ] && { echo "No screenshot tool found. Install: gnome-screenshot xfce4-screenshooter spectacle scrot"; exit 1; }

mkdir -p "$HOME/Pictures/screenshot.sh"

file="$HOME/Pictures/screenshot.sh/ss-$(date +%Y%m%d-%H%M%S).png"

case $tool in
  gnome-screenshot)    gnome-screenshot --area --clipboard --file                       "$file" ;;
  xfce4-screenshooter) xfce4-screenshooter --region --clipboard --save                  "$file" ;;
  spectacle)           spectacle -b -n -r -c -o                                         "$file" ;;
  scrot)               scrot --compression 0 --quality 100 --select --freeze --file     "$file" ;;
esac
