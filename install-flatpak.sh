#!/usr/bin/env bash

# uninstall
flatpak --system uninstall --all --force-remove --delete-data --assumeyes

# remotes
flatpak --system remote-delete --force appcenter
flatpak --system remote-delete --force elementary
flatpak --system remote-delete --force fedora
flatpak --system remote-delete --force flathub
flatpak --system remote-delete --force flathub-beta
flatpak --user remote-add flathub https://flathub.org/repo/flathub.flatpakrepo

# overrides
flatpak --user override --env=GTK_THEME=Adwaita
flatpak --user override --env=QT_QPA_PLATFORMTHEME=Breeze
flatpak --user override --env=QT_STYLE_OVERRIDE=Breeze

# update
flatpak update
flatpak update --appstream

# gnome
if [[ $(pgrep -f gnome-shell) ]]; then
	flatpak --user install flathub com.github.tchx84.Flatseal
	flatpak --user install flathub com.mattjakeman.ExtensionManager
	flatpak --user install flathub io.github.realmazharhussain.GdmSettings
fi

# gaming
flatpak --user install flathub com.valvesoftware.Steam				# steam
flatpak --user install flathub net.davidotek.pupgui2				# proton-up
flatpak --user install flathub com.usebottles.bottles				# bottles
flatpak --user install flathub io.mgba.mGBA							# mgba
flatpak --user install flathub com.dosbox_x.DOSBox-X				# dosbox-x
