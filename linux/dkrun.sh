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

if [[ -z "${1}" ]] || [[ -z "${2}" ]]; then
	usage
	exit
fi

docker container run --interactive --tty --hostname "docker-${1}-$(uuidgen | awk -F- '{print $1}')" --workdir '/' "${1}" "${2}"

# uuidgen | awk -F- '{print $1}'
