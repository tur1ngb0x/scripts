#!/usr/bin/env bash

function show { (set -x; "${@:?}"); }

function usage {
	cat << EOF
DESCRIPTION
    Run docker containers quickly.
SYNTAX
    $ ${0##*/} <image>
    $ ${0##*/} <image:tag>
    $ ${0##*/} <image:tag> <command(s)>
IMAGES
    archlinux
    amazonlinux (2023, 2, latest)
    clearlinux
    debian (bookworm, bullseye, sid)
    fedora (41, 40, rawhide)
    oraclelinux (9, 8)
    ubuntu (noble, jammy, devel)
COMMANDS
    sh, /bin/sh
    bash, /bin/bash
USAGE
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

if command -v docker &> /dev/null; then
    show docker \
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
else
    echo 'docker not found in PATH'
fi
