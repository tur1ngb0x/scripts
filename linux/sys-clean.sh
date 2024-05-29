#!/usr/bin/env bash

# command -p df -h | command -p grep -iE 'Filesystem|/dev/sd|/dev/nvme' | (command sed -u 1q;command sort)

# header function
showheader(){ tput rev; printf " %s \n" "${@}"; tput sgr0; }

# disk size function
checksize() { command -p df -h | command -p grep --color=never -vE "efi|loop|recovery|tmpfs" | (command sed -u 1q; command sort); }

# remove folder function
cleandir() { command -p rm --force --recursive "${1}" | command -p grep --color=always 'removed directory'; }

# check disk size before cleaning
checksize > /tmp/clean-pre.txt

showheader 'packages'
[[ $(command -pv apt-get) ]]				&& sudo apt-get clean
[[ $(command -pv dnf) ]]					&& sudo dnf clean all
[[ $(command -pv pacman) ]]					&& sudo pacman -Scc
[[ $(command -pv yay) ]]					&& yay -Scc
[[ $(command -pv pip) ]] 					&& pip cache purge
[[ $(command -pv flatpak) ]] 				&& flatpak uninstall --unused --delete-data

showheader 'journalctl'
[[ $(command -pv journalctl) ]] 			&& sudo journalctl --rotate
[[ $(command -pv journalctl) ]]				&& sudo journalctl --vacuum-size=1M

showheader 'docker'
[[ $(command -pv docker) ]]					&& docker system prune --all --volumes --force

showheader 'trash'
[[ -d "${HOME}"/.local/share/Trash  ]]		&& cleandir "${HOME}"/.local/share/Trash

showheader 'cache'
[[ -d "${HOME}"/.cache/thumbnails ]]		&& cleandir "${HOME}"/.cache/thumbnails
[[ -d "${HOME}"/.cache/BraveSoftware ]]		&& cleandir "${HOME}"/.cache/BraveSoftware
[[ -d "${HOME}"/.cache/google-chrome ]]		&& cleandir "${HOME}"/.cache/google-chrome
[[ -d "${HOME}"/.cache/microsoft-edge ]]	&& cleandir "${HOME}"/.cache/microsoft-edge
[[ -d "${HOME}"/.cache/mozilla ]]			&& cleandir "${HOME}"/.cache/mozilla
[[ -d "${HOME}"/.cache/fontconfig ]]		&& cleandir "${HOME}"/.cache/fontconfig
[[ -d "${HOME}"/.cache/mesa_shader_cache ]]	&& cleandir "${HOME}"/.cache/mesa_shader_cache

showheader 'cache flatpak'
[[ -d "${HOME}/.var/app/com.microsoft.Edge/config/microsoft-edge/Default/Service Worker" ]]	&& cleandir "${HOME}/.var/app/com.google.Chrome/config/google-chrome/Default/Service Worker"
[[ -d "${HOME}/.var/app/com.microsoft.Edge/config/microsoft-edge/Default/Service Worker" ]]	&& cleandir "${HOME}/.var/app/com.microsoft.Edge/config/microsoft-edge/Default/Service Worker"
[[ -d "${HOME}"/.var/app/com.brave.Browser/cache/BraveSoftware ]]							&& cleandir "${HOME}"/.var/app/com.brave.Browser/cache/BraveSoftware
[[ -d "${HOME}"/.var/app/com.google.Chrome/cache/google-chrome ]]							&& cleandir "${HOME}"/.var/app/com.google.Chrome/cache/google-chrome
[[ -d "${HOME}"/.var/app/com.microsoft.Edge/cache/microsoft-edge ]]							&& cleandir "${HOME}"/.var/app/com.microsoft.Edge/cache/microsoft-edge
[[ -d "${HOME}"/.var/app/org.mozilla.firefox/cache/mozilla ]]								&& cleandir "${HOME}"/.var/app/org.mozilla.firefox/cache/mozilla
[[ -d "${HOME}"/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/user_data ]]		&& cleandir "${HOME}"/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/user_data

showheader 'trim'
[[ $(command -pv fstrim) ]]					&& sudo fstrim --all --verbose

# check disk size after cleaning
checksize > /tmp/clean-post.txt

# print results
showheader 'before cleaning'; cat /tmp/clean-pre.txt
showheader 'after cleaning'; cat /tmp/clean-post.txt
