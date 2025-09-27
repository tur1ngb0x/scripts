#!/usr/bin/env bash

function support() {
    extensions=(
        7z
        Z
        ace
        arj
        bz2
        cab
        cpio
        deb
        gz
        lz
        lzma
        rar
        rpm
        tar.bz2
        tar.gz
        tar.lz
        tar.lzma
        tar.xz
        tar.zst
        tbz2
        tgz
        xz
        zip
        zst
    )
    count="0"
    for file_ext in "${extensions[@]}"; do
        printf "%-10s" "${file_ext}"
        count=$((count + 1))
        if [ $((count % 5)) -eq 0 ]; then
            printf "\n"
        fi
    done
    if [ $((count % 5)) -ne 0 ]; then
        printf "\n"
    fi

}

function usage {
	cat << EOF
DESCRIPTION
Extract any archive

SYNTAX
$ ${0##*/} <file>.<extension>

EXTENSIONS
$(support)

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
file_ext="${file##*.}"

extract() {
    case "${file_ext}" in
        7z)              7z x "${file}" ;;
        ace)             unace x "${file}" ;;
        arj)             arj x "${file}" ;;
        bz2)             bzip2 -dk "${file}" | tar -xf - ;;
        cab)             cabextract "${file}" ;;
        cpio)            cpio -idmv < "${file}" ;;
        deb)             ar x "${file}" ;;
        gz)              gunzip -c "${file}" | tar -xf - ;;
        iso)             7z x "${file}" ;;
        lz)              lzip -dc "${file}" | tar -xf - ;;
        lzma)            lzma -dc "${file}" | tar -xf - ;;
        rar)             unrar x "${file}" ;;
        rpm)             rpm2cpio "${file}" | cpio -idmv ;;
        tar.bz2|tbz2)    tar -xjf "${file}" ;;
        tar.gz|tgz)      tar -xzf "${file}" ;;
        tar.lz)          tar --lzip -xf "${file}" ;;
        tar.lzma)        tar --lzma -xf "${file}" ;;
        tar.xz)          tar -xJf "${file}" ;;
        tar.zst)         tar --use-compress-program=unzstd -xf "${file}" ;;
        xz)              xz -dc "${file}" | tar -xf - ;;
        Z)               uncompress "${file}" ;;
        zip)             unzip "${file}" ;;
        zst)             zstd -dc "${file}" | tar -xf - ;;
        *)               return 1 ;;
    esac
}

if extract; then
    echo "Extracted ${file} successfully."
else
    printf '%s\n' "Error: Cannot extract ${file}"
    exit 1
fi
