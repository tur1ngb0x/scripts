#!/usr/bin/env bash

LC_ALL=C

# for i in doas sudo ; do
# 	if [[ $(id -ur) -eq 0 ]]; then
# 		echo 'Re-run this script as a non-root user'; exit
# 	elif [[ $(command -v "${i}") ]]; then
# 		ELEVATE="${i}"
# 	fi
# done; echo "${ELEVATE}"

function text {
	tput rev
	printf ' %s \n' "$(command -v "${1}")"
	tput sgr0
}

function elevate_privileges {
	if [[ $(id -ur) -eq 0 ]]; then
		echo 'Re-run this script as a non-root user'
		exit
	elif [[ $(command -v doas) ]]; then
		ELEVATE="doas"
	elif [[ $(command -v sudo) ]]; then
		ELEVATE="sudo"
	fi
}

function upgrade_apt {
	text 'apt'
	{ set -x ; } &> /dev/null
	"${ELEVATE}" apt-get clean
	"${ELEVATE}" apt-get update
	"${ELEVATE}" apt-get dist-upgrade
	"${ELEVATE}" apt-get purge --autoremove
	{ set +x ; } &> /dev/null
}

function upgrade_dnf {
	text 'dnf'
	{ set -x ; } &> /dev/null
	"${ELEVATE}" dnf clean all
	"${ELEVATE}" dnf upgrade --refresh
	"${ELEVATE}" dnf autoremove
	{ set +x ; } &> /dev/null
}

function upgrade_pacman {
	text 'pacman'
	{ set -x ; } &> /dev/null
	"${ELEVATE}" reflector --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	"${ELEVATE}" pacman -Scc
	"${ELEVATE}" pacman -Syyu
	"${ELEVATE}" pacman -Fyy
	{ set +x ; } &> /dev/null
}

function upgrade_snap {
	text 'snap'
	{ set -x ; } &> /dev/null
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
	pipx upgrade-all
	{ set +x ; } &> /dev/null
}


function pm_first_party {
	for pm in apt dnf pacman; do
		if [[ -f "/usr/bin/${pm}" ]]; then
			"upgrade_${pm}"
			break
		fi; done
}

function pm_third_party {
	for pm in code docker pipx flatpak snap; do
		if [[ -f "/usr/bin/${pm}" ]]; then
			"upgrade_${pm}"
		fi; done
}

function main {
	elevate_privileges
	pm_first_party
	pm_third_party
}

# begin script from here
main "${@}"

unset LC_ALL
