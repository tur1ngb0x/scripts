#!/usr/bin/env bash

LC_ALL=C

function text {
	tput rev
	printf " %s \n" "$(which "${1}")"
	tput sgr0
}

function elevate_privileges {
	if [[ $(id -ur) -eq 0 ]]; then
		echo 'Re-run this script as a non-root user'
		exit
	fi

	if [[ $(command -v sudo) ]]; then
		ELEVATE="sudo"
	elif [[ $(command -v doas) ]]; then
		ELEVATE="doas"
	elif [[ $(command -v sudo-rs) ]]; then
		ELEVATE="sudo-rs"
	else
		echo "No elevation tool found. Please install 'doas' or 'sudo' or 'sudo-rs'"
		exit
	fi
}

function upgrade_apt {
	text 'apt'
	"${ELEVATE}" apt-get clean
	"${ELEVATE}" apt-get update
	"${ELEVATE}" apt-get dist-upgrade
	"${ELEVATE}" apt-get purge --autoremove
}

function upgrade_dnf {
	text 'dnf'
	"${ELEVATE}" dnf clean all
	"${ELEVATE}" dnf upgrade --refresh
	"${ELEVATE}" dnf autoremove
}

function upgrade_pacman {
	text 'pacman'
	"${ELEVATE}" reflector --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	"${ELEVATE}" pacman -Scc
	"${ELEVATE}" pacman -Syyu
	"${ELEVATE}" pacman -Fyy
}

function upgrade_snap {
	text 'snap'
	"${ELEVATE}" snap refresh
	"${ELEVATE}" snap refresh --hold
	"${ELEVATE}" snap set system snapshots.automatic.retention=no
	"${ELEVATE}" snap list --all | while read -r name version revision tracking publisher notes
		do if [[ "${notes}" = *disabled* ]]; then
			echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
			"${ELEVATE}" snap remove --purge "${name}" --revision="${revision}"
		fi; done
	unset name version revision tracking publisher notes
	#sudo snap remove --purge $(sudo snap list --all | awk 'NR > 1 {print $1}' | xargs)
}

function upgrade_flatpak {
	text 'flatpak'
	flatpak --user update --appstream
	flatpak --user update
	flatpak --user uninstall --unused --delete-data
	flatpak --system update --appstream
	flatpak --system update
	flatpak --system uninstall --unused --delete-data
}

function upgrade_code {
	text 'code'
	code --update-extensions
}

function upgrade_docker {
	text 'docker'
	export DOCKER_CLI_HINTS="false"
	for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
			docker pull "${img}"
	done
}

function upgrade_pipx {
	text 'pipx'
	USE_EMOJI="0" pipx upgrade-all
}

function main {
	elevate_privileges
	([[ -f /usr/bin/apt-get ]] && upgrade_apt) || ([[ -f /usr/bin/dnf ]] && upgrade_dnf) || ([[ -f /usr/bin/pacman ]] && upgrade_pacman)
	[[ -f /usr/bin/code ]] && upgrade_code
	[[ -f /usr/bin/docker ]] && upgrade_docker
	[[ -f /usr/bin/pipx ]] && upgrade_pipx
	[[ -f /usr/bin/flatpak ]] && upgrade_flatpak
	[[ -f /usr/bin/snap ]] && upgrade_snap
}

# begin script from here
main "${@}"
