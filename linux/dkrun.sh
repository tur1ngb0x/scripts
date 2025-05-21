#!/usr/bin/env bash

function show { (set -x; "${@:?}"); }

function usage {
	cat << EOF
DESCRIPTION
Manage docker containers.

SYNTAX
$ ${0##*/} <options>
$ ${0##*/} <image:tag> <command>

OPTIONS
cleanup    remove containers and images
disk       show local containers and images
images     list popular images with their tags
info       show system information
stats      show statistics

COMMANDS
sh      /bin/sh
bash    /bin/bash

USAGE
$ ${0##*/} alpine
$ ${0##*/} debian:latest
$ ${0##*/} fedora:rawhide bash
EOF
}

function docker_info {
    show docker info
}

function docker_cleanup {
    show sudo docker system prune --all --force
}

function docker_disk {
    show docker system df --verbose | awk NF
}

function docker_stats {
    show docker ps
    show docker stats --no-stream
}

function docker_run {
    local image="${1}"
    shift
	local dkrhost
	dkrhost="docker"
    # local uuidtag
    # uuidtag="$(uuidgen | awk -F '-' '{print $1}')"
    # dkrhost="docker-${image}-${uuidtag}"
    # dkrhost="${dkrhost//:/-}"
    show docker --debug=true --log-level=debug container run \
        --interactive \
        --tty \
        --cpus '2' \
        --memory '2G' \
        --user 'root' \
        --hostname "${dkrhost}" \
        --volume "${HOME}"/src/:/root/src:ro \
        --workdir '/root' \
        "${image}" \
		"${@}"
        # "${@:2}"
        # --volume "/etc/timezone:/etc/timezone:ro" \
        # --volume "/etc/localtime:/etc/localtime:ro" \
}

function docker_images () {
    cat << EOF

IMAGES          TAGS
alpine          latest, edge
archlinux       latest
debian          latest, bookworm, bullseye, sid
fedora          latest, 42, 41, rawhide
ubuntu          noble, jammy, rolling, devel
----            ----
python          latest, 3, 2
mysql           latest, 9, 8

Source: https://hub.docker.com/search
EOF
}

# if docker is not found, exit.
if ! command -v docker &> /dev/null; then
    echo 'docker not found in PATH'
    exit 1
fi

function main () {
    # switch case
    case "${1}" in
        cleanup)      docker_cleanup ;;
        disk)         docker_disk ;;
        images)       docker_images ;;
        info)         docker_info ;;
        stats)        docker_stats ;;
        '')           usage ;;
        *)            docker_run "${@}" ;;
    esac
}

# main
main "${@}"
