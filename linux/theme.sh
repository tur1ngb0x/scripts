#!/usr/bin/env bash

# Set global light mode

{ set -x; } &> /dev/null

# Cinnamon 6.4
gsettings set org.cinnamon.desktop.interface cursor-theme "Adwaita"
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita"
gsettings set org.cinnamon.desktop.interface icon-theme "Adwaita"
gsettings set org.cinnamon.theme name "Adwaita"
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
gsettings set org.cinnamon.desktop.background picture-options 'zoom'

# GNOME 49
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
gsettings set org.gnome.desktop.background picture-options 'zoom'

# MATE 1.28
gsettings set org.mate.interface cursor-theme "Adwaita"
gsettings set org.mate.interface gtk-theme "Adwaita"
gsettings set org.mate.interface icon-theme "Adwaita"
gsettings set org.mate.background picture-filename '/usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
gsettings set org.mate.background picture-options 'zoom'

# XFCE 4.21
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Adwaita"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita"
xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s '/usr/share/backgrounds/linuxmint/sele_ring_center.jpg'
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-show -s true
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 5

# Pantheon
gsettings set org.pantheon.desktop.gala.appearance gtk-theme "Adwaita"
gsettings set org.pantheon.desktop.gala.appearance icon-theme "Adwaita"
gsettings set org.pantheon.desktop.gala.appearance cursor-theme "Adwaita"
gsettings set net.launchpad.plank.dock.theme theme 'Adwaita'

# KDE Plasma
plasma-apply-lookandfeel -a org.kde.breeze.desktop

# XApps
gsettings set org.x.apps.portal color-scheme 'prefer-light'

{ set +x; } &> /dev/null
