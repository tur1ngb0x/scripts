#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <full-path-of-binary> <desktop-file-name> <app-menu-name>
Usage:
	${0##*/} '/home/user/apps/telegram/telegram' 'telegram.desktop' 'Telegram'
	${0##*/} '/home/user/apps/visual studio code/bin/code' 'vscode.desktop' 'Visual Studio Code'
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

if [[ ! -f "${1}" ]]; then
	echo 'binary name incorrect or does not exist'
	exit
fi

cat << EOF | tee "${HOME}/.local/share/applications/${2}"
[Desktop Entry]
Exec=${1}
Icon=
Name=${3}
Terminal=false
Type=Application
EOF
