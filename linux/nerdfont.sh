# #!/usr/bin/env bash

# function usage {
#     local bold=$(tput bold)
#     local reset=$(tput sgr0)
#     local rev=$(tput rev)
#     local blink=$(tput blink)
#     local dim=$(tput dim)
# 	cat << EOF

# ${rev}${bold} DESCRIPTION ${reset}
# Install https://github.com/ryanoasis/nerd-fonts in home directory

# ${rev}${bold} SYNTAX ${reset}
# $ ${0##*/} 'font-name'

# ${rev}${bold} USAGE ${reset}
# $ ${0##*/} 'CascacidaMono'
# $ ${0##*/} 'JetBrainsMono'
# $ ${0##*/} 'UbuntuMono'

# EOF
# }

function show { (set -x; "${@:?}"); }
function stdout { printf "%s\n" "${1}"; }
function header  { tput bold; tput setaf 4; printf "# %s \n" "${1}"; tput sgr0; }
function stderr { tput setaf 1; printf "# Error: %s\n" "${1}"; tput sgr0; }

# Show available fonts locally
header "Installed Fonts - ${HOME}/.local/share/fonts"
if [[ -d "${HOME}"/.local/share/fonts ]]; then
	find "${HOME}"/.local/share/fonts -mindepth 1 -type d -exec basename {} \; | awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}'
else
	echo 'No fonts installed'
fi

# Show available fonts remotely
header "Available Fonts - github.com/ryanoasis/nerd-fonts"
if [[ ! -f /tmp/nerdfont-curl ]]; then
	curl -s -L 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' > /tmp/nerdfont-curl
else
	# Process nerd font data and format it
	grep -o '/ryanoasis/nerd-fonts/tree/master/patched-fonts/[^"]*' /tmp/nerdfont-curl > /tmp/nerdfont-grep
	sed 's|/ryanoasis/nerd-fonts/tree/master/patched-fonts/||' /tmp/nerdfont-grep > /tmp/nerdfont-sed
	sort -u /tmp/nerdfont-sed > /tmp/nerdfont-sort
	awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}' /tmp/nerdfont-sort > /tmp/nerdfont-awk
	cat /tmp/nerdfont-awk
	# column -t /tmp/nerdfont-awk > /tmp/nerdfont-column
	# cat /tmp/nerdfont-column
fi

# Show installation syntax
header 'Syntax'
cat << EOF
$ nerdfont.sh 'fontname'
$ nerdfont.sh 'JetBrainsMono'
EOF

# If no fontname provided, exit immediately
if [[ -z "${1}" ]] || [[ ! $(grep "${1}" /tmp/nerdfont-awk) ]] ; then
	stderr "${1} is an invalid font name. Exiting..."
	exit
fi

# Install font
header "Installing Nerd Font - ${1}"
show mkdir -p /tmp/nerd-fonts "${HOME}"/.local/share/fonts/"${1}"
show curl -s -L -o /tmp/nerd-fonts/"${1}".tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"${1}".tar.xz
show tar --file /tmp/nerd-fonts/"${1}".tar.xz --extract --xz --directory "${HOME}"/.local/share/fonts/"${1}"
show chown -Rc "${USER}":"${USER}" "${HOME}"/.local/share/fonts
show fc-cache -r
show xdg-open "${HOME}"/.local/share/fonts &>/dev/null
header "Installed Nerd Font - ${1}"
