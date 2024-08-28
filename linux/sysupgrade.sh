#!/usr/bin/env bash

LC_ALL=C

function text { tput rev; printf ' %s \n' "${1}";tput sgr0; }

function upgrade_apt {
	text 'apt'
	{ set -x ; } &> /dev/null
	sudo apt-get clean
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get purge --autoremove
	{ set +x ; } &> /dev/null
}

function upgrade_dnf {
	text 'dnf'
	{ set -x ; } &> /dev/null
	sudo dnf clean all
	sudo dnf upgrade --refresh
	sudo dnf autoremove
	{ set +x ; } &> /dev/null
}

function upgrade_pacman {
	text 'pacman'
	{ set -x ; } &> /dev/null
	sudo reflector --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Scc
	sudo pacman -Syyu
	sudo pacman -Fyy
	{ set +x ; } &> /dev/null
}

function upgrade_snap {
	text 'snap'
	{ set -x ; } &> /dev/null
	sudo snap refresh
	sudo snap refresh --hold
	sudo snap set system snapshots.automatic.retention=no
	sudo snap list --all | while read -r name version revision tracking publisher notes
		do if [[ "${notes}" = *disabled* ]]; then
			echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
			sudo snap remove --purge "${name}" --revision="${revision}"
		fi; done
	unset name version revision tracking publisher notes
	{ set +x ; } &> /dev/null
}

function upgrade_flatpak {
	text 'flatpak'
	{ set -x ; } &> /dev/null
	flatpak --user update --appstream
	flatpak --user update
	flatpak --user uninstall --unused --delete-data
	flatpak --system update --appstream
	flatpak --system update
	flatpak --system uninstall --unused --delete-data
	{ set +x ; } &> /dev/null
}

function upgrade_code {
	text 'code'
	{ set -x ; } &> /dev/null
	code --update-extensions
	{ set +x ; } &> /dev/null
}

function upgrade_docker {
	text 'docker'
	{ set -x ; } &> /dev/null
	export DOCKER_CLI_HINTS="false"
	for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
			docker pull "${img}"
	{ set +x ; } &> /dev/null
	done
}

function upgrade_pipx {
	text 'pipx'
	{ set -x ; } &> /dev/null
	USE_EMOJI="0"; export USE_EMOJI
	pipx upgrade-all --verbose
	{ set +x ; } &> /dev/null
}

function main {
	if [[ -f /usr/bin/apt ]]; then
		upgrade_apt
	elif [[ -f /usr/bin/dnf ]]; then
		upgrade_dnf
	elif [[ -f /usr/bin/pacman ]]; then
		upgrade_pacman
	else
		text 'only apt/dnf/pacman are supported.'
	fi

	if [[ -f /usr/bin/snap ]]; then
		upgrade_snap
	fi

	if [[ -f /usr/bin/flatpak ]]; then
		upgrade_flatpak
	fi

	if [[ -f /usr/bin/code ]]; then
		upgrade_code
	fi

	if [[ -f /usr/bin/docker ]]; then
		upgrade_docker
	fi

	if [[ -f /usr/bin/pipx ]]; then
		upgrade_pipx
	fi
}

# begin script from here
main "${@}"

unset LC_ALL
