#!/usr/bin/env bash

function usage {
	cat << EOF
DESCRIPTION
    Extract any archive

SYNTAX
    $ ${0##*/} <file>.<extension>

USAGE
    $ ${0##*/} linux-kernel.tar.gz
    $ ${0##*/} images.zip
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

file="${1}"
filename="${file%.*}"
extension="${file##*.}"

case "${extension}" in
    tar.bz2|tbz2)   tar -xjf "${file}" ;;
    tar.gz|tgz)     tar -xzf "${file}" ;;
    bz2)            bzip2 -dk "${file}" | tar -xf - ;;
    rar)            unrar e "${file}" "${filename}" || unrar x "${file}" ;;
    gz)             gunzip -c "${file}" | tar -xf - ;;
    tar)            tar -xf "${file}" ;;
    zip)            unzip "${file}" ;;
    Z)              uncompress "${file}" ;;
    7z)             7z x "${file}" ;;
    deb)            ar x "${file}" ;;
    tar.xz)         tar -xf "${file}" ;;
    tar.zst)        tar -xf "${file}" ;;
    *)              echo "Unsupported archive type: .${extension}"; usage ;;
esac

if [[ ${?} -ne 0 ]]; then
    echo "Error: Cannot extract ${file}"
    exit 1
fi

echo "Extracted ${file} successfully."
