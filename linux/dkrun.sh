#!/usr/bin/env bash

usage() {
    cat << EOF

Description:
    Run docker containers quickly.

Syntax:
    $ ${0##*/} <image>
    $ ${0##*/} <image:tag>
    $ ${0##*/} <image:tag> <command(s)>

Images/Tags:
    amazonlinux: 2024, 2023
    archlinux: base
    clearlinux: base
    oraclelinux: 9, 8
    fedora: 42, 41 | rawhide
    ubuntu: noble, jammy | devel, rolling
    debian: bookworm, bullseye | sid trixie

Shells:
    Bash: bash
    Dash: dash

Usage:
    $ ${0##*/} ubuntu
    $ ${0##*/} ubuntu:devel
    $ ${0##*/} ubuntu:devel sh

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
    --hostname "${DKRHOST}" \
    --interactive \
    --tty \
    --volume "${HOME}"/src/:/root/src:ro \
    --workdir '/root' \
    "${1}" \
    "${@:2}"
