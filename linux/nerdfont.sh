#!/usr/bin/env bash

function show { (set -x; "${@:?}"); }

function usage {
    local bold=$(tput bold)
    local reset=$(tput sgr0)
    local rev=$(tput rev)
    local blink=$(tput blink)
    local dim=$(tput dim)
	cat << EOF

${rev}${bold} DESCRIPTION ${reset}
Install https://github.com/ryanoasis/nerd-fonts in home directory

${rev}${bold} SYNTAX ${reset}
$ ${0##*/} 'font-name'

${rev}${bold} USAGE ${reset}
$ ${0##*/} 'CascacidaMono'
$ ${0##*/} 'JetBrainsMono'
$ ${0##*/} 'UbuntuMono'

EOF
}


function format_list {
	awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}' "${@}"
}

function fonts_local {
	printf "Installed Fonts\n"
	find "${HOME}"/.local/share/fonts -mindepth 1 -type d -exec basename {} \; | format_list
}

function fonts_remote {

	printf "\nAvailable Fonts\n"
	if [[ ! -f /tmp/nf-folders.txt ]]; then
		(curl -s -L 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' | grep -o '/ryanoasis/nerd-fonts/tree/master/patched-fonts/[^"]*' | sed 's|/ryanoasis/nerd-fonts/tree/master/patched-fonts/||' | sort | uniq) &>/tmp/nf-folders.txt
		format_list /tmp/nf-folders.txt
	fi
}


function fonts_install {
	# Create folders
	show mkdir -p /tmp/nerd-fonts "${HOME}"/.local/share/fonts/"${1}"

	# Download font
	show curl -s -L -o /tmp/nerd-fonts/"${1}".tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"${1}".tar.xz

	# Extract fonts
	show tar --file /tmp/nerd-fonts/"${1}".tar.xz --extract --xz --directory "${HOME}"/.local/share/fonts/"${1}"

	# Fix ownership and permissions
	show chown -R "${USER}":"${USER}" "${HOME}"/.local/share/fonts

	# Regenerate font cache
	show fc-cache -r

	# Show fonts
	show xdg-open "${HOME}"/.local/share/fonts &>/dev/null
}


main () {
	if [[ "${#}" -eq 0 ]]; then
		if ! command -v curl; then echo 'curl not found, exiting...'; exit; fi
		usage
		fonts_local
		fonts_remote
		fonts_install "${1}"
		exit
	fi

}

# begin script from here

main "${@}"
