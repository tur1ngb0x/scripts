#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <brightness_value>
Usage:
	${0##*/} 0
	${0##*/} 100
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

if [[ $(command -v ddcutil) ]]; then
	printf "setting brightness to %s \n" "${1}"
	sudo bash -c "modprobe i2c-dev; ddcutil setvcp 10 ${1}"
else
	echo 'ddcutil is not installed'
	exit
fi
