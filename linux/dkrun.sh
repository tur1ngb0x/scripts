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
#PS1='\n$(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n\$ '

function dkrun-ps1 {
	PS1='\n$(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w $(git branch --show-current 2>/dev/null)\n\$ '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
}

function dkrun_apt {
	apt-get clean
	apt-get update
	apt-get dist-upgrade
	for i in ncurses micro xclip git bash-completion; do apt-get install "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
}

function dkrun-dnf {
	dnf clean all
	dnf upgrade --refresh -y
	for i in ncurses micro xclip git bash-completion; do dnf install --setopt=install_weak_deps=False "${i}" -y; done
	source /usr/share/bash-completion/bash_completion
}

function dkrun-pacman {
	rm -frv /var/lib/pacman/sync/
	rm -frv /var/cache/pacman/pkg/
	pacman -Syyu --noconfirm --needed
	for i in sudo reflector ncurses micro xclip git bash-completion base-devel; do pacman -S --noconfirm --needed "${i}" -y; done
	source /usr/share/bash-completion/bash_completion

	reflector --verbose --ipv4 --protocol http --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	rm -frv /var/lib/pacman/sync/
	rm -frv /var/cache/pacman/pkg/
	pacman -Syyu --noconfirm --needed

	rm -frv /tmp/yay*
	wget -4O '/tmp/yay.tar.gz' 'https://github.com/Jguer/yay/releases/download/v12.3.5/yay_12.3.5_x86_64.tar.gz'
	tar -xzvf /tmp/yay.tar.gz -C /tmp
	mv /tmp/yay_12.3.5_x86_64/yay /usr/local/bin/yay
}
