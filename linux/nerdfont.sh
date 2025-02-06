#!/usr/bin/env bash

function usage {
    local bold=$(tput bold)
    local reset=$(tput sgr0)
    local rev=$(tput rev)
    local blink=$(tput blink)
    local dim=$(tput dim)
	cat << EOF

${rev}${bold} DESCRIPTION ${reset}
Install https://github.com/ryanoasis/nerd-fonts in ${HOME}/.local/share/fonts

${rev}${bold} SYNTAX ${reset}
$ ${0##*/} 'font-name'

${rev}${bold} USAGE ${reset}
$ ${0##*/} 'CascacidaMono'
$ ${0##*/} 'JetBrainsMono'
$ ${0##*/} 'UbuntuMono'

EOF
}

function fonts_local {
	printf "Installed Fonts\n"
	find "${HOME}"/.local/share/fonts -mindepth 1 -type d -exec basename {} \; | awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}'
}

function fonts_remote {
	printf "\nAvailable Fonts\n"
	[[ ! -f /tmp/nf-folders.txt ]] && (curl -s -L 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' | grep -o '/ryanoasis/nerd-fonts/tree/master/patched-fonts/[^"]*' | sed 's|/ryanoasis/nerd-fonts/tree/master/patched-fonts/||' | sort | uniq) &>/tmp/nf-folders.txt
	awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}' /tmp/nf-folders.txt
}

if [[ "${#}" -eq 0 ]]; then
	usage
	fonts_local
	fonts_remote
	exit
fi

{ set -x -e; } &>/dev/null

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
xdg-open "${HOME}"/.local/share/fonts &>/dev/null

{ set +x +e; } &>/dev/null
