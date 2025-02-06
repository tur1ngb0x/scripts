#!/usr/bin/env bash

function usage {
    local bold=$(tput bold)
    local reset=$(tput sgr0)
    local rev=$(tput rev)
    local blink=$(tput blink)
    local dim=$(tput dim)
	cat << EOF
${rev}${bold} DESCRIPTION ${reset}
Run docker containers quickly.

${rev}${bold} SYNTAX ${reset}
$ ${0##*/} <image>
$ ${0##*/} <image:tag>
$ ${0##*/} <image:tag> <command(s)>

${rev}${bold} IMAGES ${reset}
archlinux
amazonlinux (2023, 2, latest)
clearlinux
debian (bookworm, bullseye, sid)
fedora (41, 40, rawhide)
oraclelinux (9, 8)
ubuntu (noble, jammy, devel)

${rev}${bold} COMMANDS ${reset}
sh, /bin/sh
bash, /bin/bash

${rev}${bold} USAGE ${reset}
$ ${0##*/} archlinux
$ ${0##*/} debian:sid sh
$ ${0##*/} ubuntu:devel
EOF
}

if [[ "${#}" -eq 0 ]]; then
    usage
    exit
fi

UUIDTAG="$(uuidgen | awk -F '-' '{print $1}')"
DKRHOST="docker-${1}-${UUIDTAG}"
DKRHOST="${DKRHOST//:/-}"

docker \
    --debug \
    --log-level 'debug' \
    container run \
    --interactive \
    --tty \
    --hostname "${DKRHOST}" \
    --volume "${HOME}"/src/:/root/src:ro \
    --workdir '/root' \
    "${1}" \
    "${@:2}"
