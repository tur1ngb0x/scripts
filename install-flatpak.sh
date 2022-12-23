#!/usr/bin/env bash

flatpak --user remote-add flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak --user install flathub --assumeyes io.mgba.mGBA
flatpak --user install flathub --assumeyes xyz.z3ntu.razergenie
flatpak --user install flathub --assumeyes com.dosbox_x.DOSBox-X
flatpak --user install flathub --assumeyes com.valvesoftware.Steam
flatpak --user install flathub --assumeyes com.heroicgameslauncher.hgl

if [[ $(pgrep -f gnome-shell) ]]; then
	flatpak --user override --env=QT_QPA_PLATFORMTHEME=Breeze
	flatpak --user override --env=QT_STYLE_OVERRIDE=Breeze
	flatpak --user install flathub --assumeyes com.github.tchx84.Flatseal
	flatpak --user install flathub --assumeyes com.mattjakeman.ExtensionManager
fi
