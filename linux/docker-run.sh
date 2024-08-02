#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <image:tag> <command>
Usage:
	${0##*/} 'debian' sh
	${0##*/} 'ubuntu' bash
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

docker --debug --log-level 'debug' container run --interactive --tty --cpus '2' --memory '4096m' --hostname 'docker' --workdir '/root' "${1}" "${@:2}"

# PS1
# PS1='$(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n\$ '
# DNF
# dnf clean all; dnf upgrade --refresh --assumeyes; dnf install --setopt=install_weak_deps=False --assumeyes ncurses micro xclip git bash-completion
# PACMAN
# pacman -Scc --noconfirm; pacman -Syyu --noconfirm; pacman -S --noconfirm reflector micro xclip git bash-completion; source /usr/share/bash-completion/bash_completion
# reflector --verbose --ipv4 --protocol http --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist; pacman -Scc --noconfirm; pacman -Syyu --noconfirm
