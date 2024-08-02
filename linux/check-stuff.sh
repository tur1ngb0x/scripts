#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <option>
Options:
	ip	ip address
	mem	memory
	path	PATH variable
	ping	packet connectivity
	route	packet routing
Usage:
	${0##*/} ip
	${0##*/} ping google.com
	${0##*/} route google.com
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

option="${1}"
shift

case "${option}" in
	ip)		curl ifconfig.me/all ;;
	mem)	watch --interval 1 'free --mebi --lohi --total --wide' ;;
	path)	echo "${PATH}" | tr ":" "\n" ;;
	ping)	ping -4 "${@}" ;;
	route)	traceroute -4 "${@}" ;;
	*)		usage ;;
esac
