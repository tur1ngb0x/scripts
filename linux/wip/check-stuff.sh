#!/usr/bin/env bash

usage()
{
    cat << EOF
DESCRIPTION
    Perform various checks on the system
SYNTAX
    $ ${0##*/} <option>
OPTIONS
    ip	get ip address
    mem	check memory usage
    path	check PATH variable
    ping	check packet connectivity
    route	check packet routing
USAGE
    $ ${0##*/} ip
    $ ${0##*/} ping google.com
    $ ${0##*/} route google.com
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
    mem)	free --mebi --lohi --total --wide ;;
    path)	tr ":" "\n" <<< "${PATH}" ;;
    ping)	ping -4 -c10 "${@}" ;;
    route)	traceroute -4 "${@}" ;;
    *)		usage ;;
esac
