#!/usr/bin/env bash

usage() {
	cat << EOF

Description:
    Search text in a given directory

Syntax:
    $ ${0##*/} <pattern> <directory>

Usage:
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
