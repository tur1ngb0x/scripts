#!/usr/bin/env bash

usage() {
	cat << EOF
DESCRIPTION
    Search text in a given directory
SYNTAX
    $ ${0##*/} <pattern> <directory>
USAGE
    $ ${0##*/} git .
    $ ${0##*/} apt /etc/apt
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

printf "searching for %s in %s" "${1}" "${2}"
grep --color=always --ignore-case --binary-files=without-match --with-filename --recursive --line-number "${1}" "${2}" 2>/dev/null | less -r
