#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	vboxset.sh <vm-name>
Usage:
	vboxset.sh ubuntu-jammy
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

tput rev; tput blink; tput bold; echo ' creating ${HOME}/src/vbox/data '; tput sgr0
mkdir -pv "${HOME}/src/vbox/data"

tput rev; tput blink; tput bold; echo ' changing vm properties '; tput sgr0
vboxmanage modifyvm "${1}" --cpus 2 --memory 4096 --vram 256 --drag-and-drop bidirectional --clipboard-mode bidirectional --boot1 dvd --boot2 disk --boot3 none --boot4 none
vboxmanage storageattach "${1}" --storagectl "SATA" --port 0 --nonrotational on

tput rev; tput blink; tput bold; echo ' adding shared folder to vm '; tput sgr0
vboxmanage sharedfolder add "${1}" --name data --hostpath "${HOME}/src/vbox/data" --automount
