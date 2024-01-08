#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <target> <owner>:<group>
Usage:
	${0##*/} /home/user/dotfiles user:user
	${0##*/} /etc/apt root:root
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

tput rev; tput blink; tput bold; echo ' fixing folder ownership '; tput sgr0
find -L "${1}" -type d -exec chown --verbose --changes "${2}" {} \;

tput rev; tput blink; tput bold; echo ' fixing file ownership '; tput sgr0
find -L "${1}" -type f -exec chown --verbose --changes "${2}" {} \;
