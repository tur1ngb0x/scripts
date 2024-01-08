#!/usr/bin/env bash

header() { tput rev; tput blink; tput bold; echo "${1}"; tput sgr0; }

[[ -f /usr/bin/apt-get ]]	&&	header '# /usr/bin/apt-get'	&&	(sudo apt clean && sudo apt update && sudo apt full-upgrade)
[[ -f /usr/bin/dnf ]]		&&	header '# /usr/bin/dnf'		&&	sudo dnf upgrade --refresh
[[ -f /usr/bin/pacman ]]	&&	header '# /usr/bin/pacman'	&&	sudo pacman --sync --refresh --sysupgrade
[[ -f /usr/bin/snap ]]		&&	header '# /usr/bin/snap'	&&	sudo snap refresh
[[ -f /usr/bin/flatpak ]]	&&	header '# /usr/bin/flatpak'	&&	(flatpak --user update --appstream && flatpak --user update --assumeyes)
[[ -f /usr/bin/pipx ]]		&&	header '# /usr/bin/pipx'	&&	pipx upgrade-all
