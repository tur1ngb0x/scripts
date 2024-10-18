#!/usr/bin/env bash

usage() {
	cat <<EOF
Description:
	Open a file or folder using Visual Studio Code as superuser
Syntax:
	$ ${0##*/} <file/folder>
Usage:
	$ ${0##*/} /etc/default/grub
	$ ${0##*/} /etc/apt/
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

tput rev
echo -e "\n opening ${*} with $(which code) as superuser \n"
tput sgr0

sudo code \
	--disable-chromium-sandbox \
	--disable-extensions \
	--disable-gpu \
	--disable-lcd-text \
	--locale en \
	--no-sandbox \
	--reuse-window \
	--sync off \
	--user-data-dir /tmp \
	"${@}"
