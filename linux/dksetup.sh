#!/usr/bin/env bash

function docker-ps1 {
	{ set -x; } &>/dev/null
	PS1='\[\e[7m\]\n $(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n \$ \[\e[0m\] '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
	{ set +x; } &>/dev/null
}

function docker-apt {
	{ set -x; } &>/dev/null
	apt-get clean
	apt-get update
	apt-get dist-upgrade -y
	for i in bash-completion git micro ncurses wget xclip; do apt-get install "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
	{ set +x; } &>/dev/null
}

function docker-dnf {
	{ set -x; } &>/dev/null
	dnf clean all
	dnf upgrade --refresh -y
	for i in bash-completion git micro ncurses wget xclip; do dnf install --setopt=install_weak_deps=False "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
	{ set +x; } &>/dev/null
}

function docker-pacman {
	{ set -x; } &>/dev/null
	rm -frv /var/lib/pacman/sync/
	rm -frv /var/cache/pacman/pkg/
	for i in sudo reflector bash-completion git micro ncurses wget xclip; do pacman -Syyu --noconfirm --needed "${i}" -y; done
	source /usr/share/bash-completion/bash_completion

	reflector --verbose --ipv4 --protocol http --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	rm -frv /var/lib/pacman/sync/
	rm -frv /var/cache/pacman/pkg/
	pacman -Syyu --noconfirm --needed
	{ set +x; } &>/dev/null
}

# detect package managers
if [[ -f /usr/bin/apt ]]; then
	PKG="apt"
elif [[ -f /usr/bin/dnf ]]; then
	PKG="dnf"
elif [[ -f /usr/bin/pacman ]]; then
	PKG="pacman"
else
	PKG="na"
	echo 'unsupported package manager'
	exit
fi

# set PS1 variable
docker-ps1

# launch distro specific functions
case "${PKG}" in
	apt) docker-apt ;;
	dnf) docker-dnf ;;
	pacman) docker-pacman ;;
	*) echo 'unsupported package manager' ;;
esac
