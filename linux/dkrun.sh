#!/usr/bin/env bash

usage()
{
	cat << EOF

Description:
    Run docker containers quickly.

Syntax:
    $ ${0##*/} <image>
    $ ${0##*/} <image:tag>
    $ ${0##*/} <image:tag> <command(s)>

Usage:
    $ ${0##*/} ubuntu
    $ ${0##*/} ubuntu:devel
    $ ${0##*/} ubuntu:devel sh

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
	--hostname 'docker' \
	--interactive \
	--tty \
	--volume /home/pd/src/:/root/src \
	--workdir '/root' \
	"${1}" \
	"${@:2}"

function dkrun-ps1 {
	PS1='\[\e[7m\]\n $(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n \$ \[\e[0m\] '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
}; dkrun-ps1

PS1='\[\e[7m\]\u\[\e[0m\]'

function dkrun-git {
	git clone --depth=1 https://github.com/tur1ngb0x/dotfiles "${HOME}"/dotfiles
	git clone --depth=1 https://github.com/tur1ngb0x/scripts "${HOME}"/scripts
}

function dkrun-apt {
	apt-get clean
	apt-get update
	apt-get dist-upgrade
	for i in bash-completion git micro ncurses wget xclip; do apt-get install "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
}

function dkrun-dnf {
	dnf clean all
	dnf upgrade --refresh -y
	for i in bash-completion git micro ncurses wget xclip; do dnf install --setopt=install_weak_deps=False "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
}

function dkrun-pacman {
	rm -frv /var/lib/pacman/sync/
	rm -frv /var/cache/pacman/pkg/
	for i in sudo reflector bash-completion git micro ncurses wget xclip ; do pacman -Syyu --noconfirm --needed "${i}" -y; done
	source /usr/share/bash-completion/bash_completion

	#reflector --verbose --ipv4 --protocol http --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	#rm -frv /var/lib/pacman/sync/
	#rm -frv /var/cache/pacman/pkg/
	#pacman -Syyu --noconfirm --needed

	#rm -frv /tmp/yay.tar.gz /tmp/yay_12.3.5_x86_64/
	#wget -4O '/tmp/yay.tar.gz' 'https://github.com/Jguer/yay/releases/download/v12.3.5/yay_12.3.5_x86_64.tar.gz'
	#tar -xzvf /tmp/yay.tar.gz -C /tmp
	#mv /tmp/yay_12.3.5_x86_64/yay /usr/local/bin/yay
}
