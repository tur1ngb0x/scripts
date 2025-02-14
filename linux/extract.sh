#!/usr/bin/env bash

# usage() {
#     cat <<EOF

# Description:
#     Univeral archive extractor.

# Syntax:
#     $ ${0##*/} <file>.<extension>

# Usage:
#     $ ${0##*/} linux-kernel.tar.gz
#     $ ${0##*/} images.zip

# EOF
# }

# if [[ "${#}" -eq 0 ]]; then
#     usage
#     exit
# fi

# # extract files
# case "${1}" in
#     *.tar.bz2) tar -xjf "${1}" ;;
#     *.tar.gz) tar -xzf "${1}" ;;
#     *.bz2) tar -xjf "${1}" ;;
#     *.rar) unrar -x "${1}" ;;
#     *.gz) tar -xf "${1}" ;;
#     *.tar) tar -xf "${1}" ;;
#     *.tbz2) tar -xjf "${1}" ;;
#     *.tgz) tar -xzf "${1}" ;;
#     *.zip) unzip "${1}" ;;
#     *.Z) uncompress "${1}" ;;
#     *.7z) 7z -x "${1}" ;;
#     *.deb) ar -x "${1}" ;;
#     *.tar.xz) tar -xf "${1}" ;;
#     *.tar.zst) tar -xf "${1}" ;;
#     *) usage ;;
# esac

function usage {
    local Treset=$(tput sgr0)
    local Tbold=$(tput bold)
    local Titalic=$(tput sitm)
    local Tunderline=$(tput ul)
    local Treverse=$(tput rev)
    local Tdim=$(tput dim)
	cat << EOF

${Treverse}${Tbold} DESCRIPTION ${Treset}
Extract any archive

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <file>.<extension>

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/} linux-kernel.tar.gz
$ ${0##*/} images.zip

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi


file="$1"
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

if [[ $? -ne 0 ]]; then
    echo "Error extracting ${file}"
    exit 1
fi

echo "Extracted ${file} successfully."
