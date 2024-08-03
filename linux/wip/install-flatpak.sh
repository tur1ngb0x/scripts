#!/usr/bin/env bash


# install flatpak
sudo add-apt-repository -y ppa:flatpak/stable; sudo apt-get update; sudo apt-get install -y flatpak
sudo dnf install -y flatpak
sudo pacman -Syu flatpak

# manage remotes
flatpak remote-delete flathub
flatpak remote-delete fedora
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# flatpak packages
pkgs_flatpak=(
	# browsers
	com.google.Chrome
	com.microsoft.Edge
	org.mozilla.firefox
	# messaging
	com.discordapp.Discord
	org.telegram.desktop
	# gaming
	com.valvesoftware.Steam
	io.mgba.mGBA
	# misc
	com.github.tchx84.Flatseal
	org.kde.gwenview
	org.kde.kolourpaint
	org.kde.okular
	org.qbittorrent.qBittorrent
	org.videolan.VLC
)

# install flatpaks
for pkg in "${pkgs_flatpak[@]}"; do flatpak --user install flathub --assumeyes --or-update "${pkg}"; done
