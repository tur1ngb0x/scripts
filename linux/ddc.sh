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

tput rev; echo " setting brightness to ${1} "; tput sgr0
sudo bash -c "modprobe i2c-dev; ddcutil setvcp 10 ${1}"
