#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <target> <dir-perm> <file-perm>
Usage:
	${0##*/} /home/user/dotfiles 0755 0644
	${0##*/} /home/user/.ssh 0700 0600
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

tput rev; tput blink; tput bold; echo ' fixing file permissions '; tput sgr0
find -L "${1}" -type d -exec chmod --verbose --changes "${2}" {} \;

tput rev; tput blink; tput bold; echo ' fixing file permissions '; tput sgr0
find -L "${1}" -type f -exec chmod --verbose --changes "${3}" {} \;
