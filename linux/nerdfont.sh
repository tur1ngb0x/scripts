#!/usr/bin/env bash

function usage {
	cat << EOF

Description:
Install https://github.com/ryanoasis/nerd-fonts in ${HOME}/.local/share/fonts

Syntax:
$ ${0##*/} 'font-name'

Usage:
$ ${0##*/} 'Terminus'

EOF
}

function get_fonts {
	echo "Fonts:"
	[[ ! -f /tmp/nf-folders.txt ]] && (curl -s -L 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' | grep -o '/ryanoasis/nerd-fonts/tree/master/patched-fonts/[^"]*' | sed 's|/ryanoasis/nerd-fonts/tree/master/patched-fonts/||' | sort | uniq) &> /tmp/nf-folders.txt
	awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}' /tmp/nf-folders.txt
}

if [[ "${#}" -eq 0 ]]; then
	usage; get_fonts; exit
fi

{ set -x -e; } &> /dev/null

# Create folders
mkdir -p /tmp/nerd-fonts "${HOME}"/.local/share/fonts/"${1}"

# Download font
curl -s -L -o /tmp/nerd-fonts/"${1}".tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"${1}".tar.xz

# Extract fonts
tar --file /tmp/nerd-fonts/"${1}".tar.xz --extract --xz --directory "${HOME}"/.local/share/fonts/"${1}"

# Fix ownership and permissions
chown -R "${USER}":"${USER}" "${HOME}"/.local/share/fonts

# Regenerate font cache
fc-cache -r

# Show fonts
xdg-open "${HOME}"/.local/share/fonts &> /dev/null

{ set +x +e; } &> /dev/null
