#!/usr/bin/env bash

usage() {
	cat << EOF

Description:
    Collection of adb commands to perform tasks.

Syntax:
    $ ${0##*/} <option>

Options:
    opt     Optimize apps.
    reboot  Reboot the device.

Usage:
    $ ${0##*/} opt
    $ ${0##*/} reboot

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

adb stop-server
adb start-server

echo "Enter option:"
read -r option

case "${option}" in
    opt)    adb shell cmd package bg-dexopt-job ;;
    reboot) adb reboot ;;
    *)      echo "Invalid selection. Please enter a number between 1 and 5." ;;
esac
