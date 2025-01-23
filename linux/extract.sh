#!/usr/bin/env bash

usage() {
    cat <<EOF

Description:
    Univeral archive extractor.

Syntax:
    $ ${0##*/} <file>.<extension>

Usage:
    $ ${0##*/} linux-kernel.tar.gz
    $ ${0##*/} images.zip

EOF
}

if [[ "${#}" -eq 0 ]]; then
    usage
    exit
fi

# extract files
case "${1}" in
    *.tar.bz2) tar -xjf "${1}" ;;
    *.tar.gz) tar -xzf "${1}" ;;
    *.bz2) tar -xjf "${1}" ;;
    *.rar) unrar -x "${1}" ;;
    *.gz) tar -xf "${1}" ;;
    *.tar) tar -xf "${1}" ;;
    *.tbz2) tar -xjf "${1}" ;;
    *.tgz) tar -xzf "${1}" ;;
    *.zip) unzip "${1}" ;;
    *.Z) uncompress "${1}" ;;
    *.7z) 7z -x "${1}" ;;
    *.deb) ar -x "${1}" ;;
    *.tar.xz) tar -xf "${1}" ;;
    *.tar.zst) tar -xf "${1}" ;;
    *) usage ;;
esac
