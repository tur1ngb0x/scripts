#!/usr/bin/env bash

LC_ALL=C
set -euo pipefail

if [[ $# -ne 1 ]]; then
    cat << EOF
Usage:
theme.sh <option>

Options:
cinnamon, gnome, mate, xfce, pantheon, plasma, xapps
EOF
    exit
fi

_cinnamon(){
    if ! command -v gsettings &>/dev/null; then echo 'gsettings not found...' && exit; fi
    gsettings set org.cinnamon.desktop.interface cursor-theme "Adwaita"
    gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita"
    gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
    gsettings set org.cinnamon.theme name "Adwaita"
    # gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
    # gsettings set org.cinnamon.desktop.background picture-options 'zoom'
}

_gnome(){
    if ! command -v gsettings &>/dev/null; then echo 'gsettings not found...' && exit; fi
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
    # gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
    # gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
    # gsettings set org.gnome.desktop.background picture-options 'zoom'
}

_mate(){
    if ! command -v gsettings &>/dev/null; then echo 'gsettings not found...' && exit; fi
    gsettings set org.mate.interface cursor-theme "Adwaita"
    gsettings set org.mate.interface gtk-theme "Adwaita"
    gsettings set org.mate.interface icon-theme "Adwaita"
    # gsettings set org.mate.background picture-filename '/usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
    # gsettings set org.mate.background picture-options 'zoom'
}

_xfce() {
    if ! command -v xfconf-query &>/dev/null; then echo 'xfconf-query not found...' && exit; fi
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Adwaita"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita"
    xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
    # xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s '/usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
    # xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-show -s true
    # xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 5
}

_pantheon() {
    if ! command -v gsettings &>/dev/null; then echo 'gsettings not found...' && exit; fi
    gsettings set org.pantheon.desktop.gala.appearance gtk-theme "Adwaita"
    gsettings set org.pantheon.desktop.gala.appearance icon-theme "Adwaita"
    gsettings set org.pantheon.desktop.gala.appearance cursor-theme "Adwaita"
    gsettings set net.launchpad.plank.dock.theme theme 'Adwaita'
}

_plasma() {
    if ! command -v plasma-apply-lookandfeel &>/dev/null; then echo 'plasma-apply-lookandfeel not found...' && exit; fi
    plasma-apply-lookandfeel -a org.kde.breeze.desktop
}

_xapps() {
    if ! command -v gsettings &>/dev/null; then echo 'gsettings not found...' && exit; fi
    gsettings set org.x.apps.portal color-scheme 'prefer-light'
}


_error() {
    cat << EOF
Valid options - cinnamon, gnome, mate, xfce, pantheon, plasma, xapps
EOF
}

main() {
    case "${1}" in
        cinnamon) _cinnamon ;;
        gnome) _gnome ;;
        mate) _mate ;;
        xfce) _xfce ;;
        pantheon) _pantheon ;;
        plasma) _plasma ;;
        xapps) _xapps ;;
        *) _error; exit 1 ;;
    esac
}

main "${@}"
