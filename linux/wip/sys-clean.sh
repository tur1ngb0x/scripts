#!/usr/bin/env bash

function showheader {
	tput rev
	printf "\n %s \n" "${@}"
	tput sgr0
}

function checksize {
	command -p df -h | command -p grep --color=never -vE "efi|loop|recovery|tmpfs" | (command sed -u 1q; command sort)
}

function cleandir() {
	[[ -d "${1}" ]] && command -p rm --force --recursive "${1}"
}

# begin script from here
checksize > /tmp/clean-pre.txt

showheader 'packages'
[[ $(command -pv apt-get) ]] && sudo apt-get clean
[[ $(command -pv dnf) ]] && sudo dnf clean all
[[ $(command -pv pacman) ]] && sudo pacman -Scc
[[ $(command -pv yay) ]] && yay -Scc
[[ $(command -pv pip) ]] && pip cache purge
[[ $(command -pv flatpak) ]] && flatpak uninstall --unused --delete-data

showheader 'journalctl'
[[ $(command -pv journalctl) ]] && sudo journalctl --rotate && sudo journalctl --vacuum-size=1M

showheader 'docker'
[[ $(command -pv docker) ]] && docker system prune --all --volumes --force

showheader 'trash'
cleandir "${HOME}"/.local/share/Trash

showheader 'cache'
cleandir "${HOME}/.cache/thumbnails"
cleandir "${HOME}/.cache/BraveSoftware"
cleandir "${HOME}/.cache/google-chrome"
cleandir "${HOME}/.cache/microsoft-edge"
cleandir "${HOME}/.cache/mozilla"
cleandir "${HOME}/.cache/fontconfig"
cleandir "${HOME}/.cache/mesa_shader_cache"

showheader 'cache flatpak'
cleandir "${HOME}/.var/app/com.brave.Browser/cache/BraveSoftware"
cleandir "${HOME}/.var/app/com.google.Chrome/cache/google-chrome"
cleandir "${HOME}/.var/app/com.microsoft.Edge/cache/microsoft-edge"
cleandir "${HOME}/.var/app/org.mozilla.firefox/cache/mozilla"

showheader 'trim'
[[ $(command -pv fstrim) ]] && sudo fstrim --all --verbose

checksize > /tmp/clean-post.txt

showheader 'before cleaning'; cat /tmp/clean-pre.txt
showheader 'after cleaning'; cat /tmp/clean-post.txt
