#!/usr/bin/env bash

usage()
{
	cat << EOF

Description:
    Run docker containers quickly.

Syntax:
    $ ${0##*/} <image>     <command>
    $ ${0##*/} <image:tag> <command>

Usage:
    $ ${0##*/} 'archlinux' sh
    $ ${0##*/} 'ubuntu:noble' bash

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

docker \
	--debug \
	--log-level 'debug' \
	container run \
	--interactive \
	--tty \
	--cpus '2' \
	--memory '4096m' \
	--hostname 'docker' \
	--workdir '/root' \
	"${1}" \
	"${@:2}"

# PS1
# PS1='\n$(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n\$ '

# APT
# apt-get clean; apt-get update; apt-get dist-upgrade; apt-get install micro xclip git bash-completion -y; source /usr/share/bash-completion/bash_completion

# DNF
# dnf clean all; dnf upgrade --refresh -y; dnf install --setopt=install_weak_deps=False ncurses micro xclip git bash-completion -y; source /usr/share/bash-completion/bash_completion

# PACMAN
# pacman -Scc --noconfirm; pacman -Syyu --noconfirm; pacman -S --noconfirm reflector micro xclip git bash-completion; source /usr/share/bash-completion/bash_completion
# reflector --verbose --ipv4 --protocol http --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist; pacman -Scc --noconfirm; pacman -Syyu --noconfirm
