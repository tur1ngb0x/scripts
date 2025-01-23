#!/usr/bin/env bash

usage() {
	cat << EOF

Description:
    Change the brightness level of the monitor using ddcutil.

Syntax:
    $ ${0##*/} <value>

Usage:
    $ ${0##*/} 0
    $ ${0##*/} 50
    $ ${0##*/} 100

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

printf "setting brightness to %s \n" "${1}"
sudo bash -c "modprobe i2c-dev; ddcutil setvcp 10 ${1}"
