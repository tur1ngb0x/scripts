#!/usr/bin/env bash

function show { (set -x; "${@:?}"); }

function usage () {
    Treset=$(tput sgr0)
    Tbold=$(tput bold)
    Titalic=$(tput sitm)
    Tunderline=$(tput ul)
    Treverse=$(tput rev)
    Tdim=$(tput dim)
    cat << EOF
${Treverse}${Tbold} DESCRIPTION ${Treset}
Bash wrapper for quickly spinning up docker containers.

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <options>
$ ${0##*/} <image:tag> <command>

${Treverse}${Tbold} OPTIONS ${Treset}
check      check common issues and problems
cleanup    remove local images and containers
disk       show local images and containers
images     list popular images with their tags
info       show system information
stats      show local containers statistics
help       show help

${Treverse}${Tbold} COMMANDS ${Treset}
sh      /bin/sh
bash    /bin/bash
dash    /bin/dash

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/} alpine
$ ${0##*/} debian:latest
$ ${0##*/} fedora:rawhide bash
$ ${0##*/} archlinux:latest bash -c 'cat /etc/pacman.conf'
EOF
}

function docker_check () {
    show command -v docker
	show type docker
	show which docker
    show docker --version
    show systemctl is-active docker.service
    show file /var/run/docker.sock
    show id -Grn | grep docker
    show docker container run --rm hello-world
}

function docker_info () {
    show docker info
}

function docker_cleanup () {
    show sudo docker system prune --all --force
}

function docker_disk () {
    show docker system df --verbose | awk NF
}

function docker_stats () {
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



function main () {
	if ! command -v docker &> /dev/null; then
		echo 'docker not found in PATH'
		exit 1
	fi
    case "${1}" in
        check)								docker_check      ;;
        cleanup)      						docker_cleanup    ;;
        disk)         						docker_disk       ;;
        images)       						docker_images     ;;
        info)         						docker_info       ;;
        stats)        						docker_stats      ;;
        ''|help|-help|--help|h|-h|--h)      usage             ;;
        *)    								docker_run "${@}" ;;
    esac
}

# main
main "${@}"
