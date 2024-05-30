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


docker container run --interactive --tty --hostname "docker-${1}-$(uuidgen | awk -F- '{print $1}')" --workdir "/" "${1}" "${@:2}"

# uuidgen | awk -F- '{print $1}'

# -e "PS1=$(source /etc/os-release; echo ${ID}-${VERSION_ID}) \u@\h \w\n\$ "
