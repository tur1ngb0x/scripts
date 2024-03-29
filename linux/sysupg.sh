#!/usr/bin/env bash

header(){
	tput rev
	printf ' %s \n' "${1}";
	tput sgr0
}

upg_apt(){
	header 'apt'
	{ set -x ; } &> /dev/null
	sudo apt-get clean
	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get purge --autoremove
	{ set +x ; } &> /dev/null
}

upg_dnf(){
	header 'dnf'
	{ set -x ; } &> /dev/null
	sudo dnf  clean all
	sudo dnf upgrade --refresh
	sudo dnf autoremove
	{ set +x ; } &> /dev/null
}

upg_pacman(){
	header 'pacman'
	{ set -x ; } &> /dev/null
	sudo reflector --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Scc
	sudo pacman -Syyu
	sudo pacman -Fyy
	{ set +x ; } &> /dev/null
}

upg_snap(){
	header 'snap'
	{ set -x ; } &> /dev/null
	sudo snap refresh
	sudo snap refresh --hold
	sudo snap set system snapshots.automatic.retention=no
	LANG=C sudo snap list --all | while read -r name version revision tracking publisher notes
		do if [[ "${notes}" = *disabled* ]]; then
			echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
			sudo snap remove --purge "${name}" --revision="${revision}"
		fi; done
	unset name version revision tracking publisher notes
	{ set +x ; } &> /dev/null
}

upg_flatpak(){
	header 'flatpak'
	{ set -x ; } &> /dev/null
	flatpak --user update --appstream
	flatpak --user update
	flatpak --user uninstall --unused --delete-data
	flatpak --system update --appstream
	flatpak --system update
	flatpak --system uninstall --unused --delete-data
	{ set +x ; } &> /dev/null
}

upg_code(){
	header 'code'
	{ set -x ; } &> /dev/null
	code --update-extensions
	{ set +x ; } &> /dev/null
}

upg_docker(){
	header 'docker'
	{ set -x ; } &> /dev/null
	for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
		DOCKER_CLI_HINTS="false" docker pull "${img}"
	done
	{ set +x ; } &> /dev/null
}

upg_pipx(){
	header 'pipx'
	{ set -x ; } &> /dev/null
	USE_EMOJI="0" pipx upgrade-all
	{ set +x ; } &> /dev/null
}

# begin script from here
if [[ -f /usr/bin/apt ]]; then
	upg_apt
elif [[ -f /usr/bin/dnf ]]; then
	upg_dnf
elif [[ -f /usr/bin/pacman ]]; then
	upg_pacman
else
	header 'only apt/dnf/pacman are supported.'
fi

if [[ -f /usr/bin/snap ]]; then
	upg_snap
fi

if [[ -f /usr/bin/flatpak ]]; then
	upg_flatpak
fi

if [[ -f /usr/bin/code ]]; then
	upg_code
fi

if [[ -f /usr/bin/docker ]]; then
	upg_docker
fi

if [[ -f /usr/bin/pipx ]]; then
	upg_pipx
fi
