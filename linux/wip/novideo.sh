#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <mode>
Usage:
	${0##*/} integrated
	${0##*/} hybrid
	${0##*/} nvidia
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

tput rev; tput bold; printf "%s\n" "downloading envycontrol"; tput sgr0;
if [[ $(command -pv wget) ]]; then
	wget -4O /tmp/envycontrol.py 'https://raw.githubusercontent.com/bayasdev/envycontrol/main/envycontrol.py'
else
	echo 'wget not found' && exit
fi

tput rev; tput bold; printf "%s\n" "setting prime-select to ondemand"; tput sgr0;
if [[ $(command -pv prime-select) ]]; then
	sudo prime-select on-demand
else
	echo 'prime-select not found, skipping.'
fi

tput rev; tput bold; printf "%s\n" "masking gpu-manager.service"; tput sgr0;
if [[ $(systemctl --no-pager --plain list-unit-files | grep 'gpu-manager.service') ]]; then
	sudo systemctl mask gpu-manager.service
else
	echo 'gpu-manager.service not found, skipping.'
fi

tput rev; tput bold; printf "%s\n" "checking current graphics mode"; tput sgr0;
if [[ $(command -pv python) ]]; then
	sudo python /tmp/envycontrol.py --query
elif [[ $(command -pv python3) ]]; then
	sudo python3 /tmp/envycontrol.py --query
else
	echo 'python not found'
fi

tput rev; tput bold; printf "%s\n" "setting graphics mode to ${1}"; tput sgr0;
if [[ $(command -pv python) ]]; then
	sudo python /tmp/envycontrol.py --switch "${1}"
elif [[ $(command -pv python3) ]]; then
	sudo python3 /tmp/envycontrol.py --switch "${1}"
else
	echo 'python not found'
fi

tput rev; tput bold; printf "%s\n" "checking current graphics mode"; tput sgr0;
if [[ $(command -pv python) ]]; then
	sudo python /tmp/envycontrol.py --query
elif [[ $(command -pv python3) ]]; then
	sudo python3 /tmp/envycontrol.py --query
else
	echo 'python not found'
fi
