#!/usr/bin/env bash

# default help function
usage()
{
	cat << EOF
Syntax:
	${0##*/} <filename.extension>
Usage:
	${0##*/} linux-kernel.tar.gz
	${0##*/} images.zip
EOF
	exit
}

# if no arguments, print help and exit
if [[ "${#}" -eq 0 ]]; then
	usage
fi

# extract files
case "${1}" in
	*.tar.bz2)		tar xjf		"${1}"		;;
	*.tar.gz)		tar xzf		"${1}"		;;
	*.bz2)			tar xjf		"${1}"		;;
	*.rar)			unrar x		"${1}"		;;
	*.gz)			tar xf		"${1}"		;;
	*.tar)			tar xf		"${1}"		;;
	*.tbz2)			tar xjf		"${1}"		;;
	*.tgz)			tar xzf		"${1}"		;;
	*.zip)			unzip		"${1}"		;;
	*.Z)			uncompress	"${1}"		;;
	*.7z)			7z x		"${1}"		;;
	*.deb)			ar x		"${1}"		;;
	*.tar.xz)		tar xf		"${1}"		;;
	*.tar.zst)		tar xf		"${1}"		;;
	*)				usage					;;
esac
