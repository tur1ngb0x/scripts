#!/usr/bin/env bash

usage() {
	cat <<EOF

Description:
    Run docker containers quickly.

Syntax:
    $ ${0##*/} <image>
    $ ${0##*/} <image:tag>
    $ ${0##*/} <image:tag> <command(s)>

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

docker \
	--debug \
	--log-level 'debug' \
	container run \
	--hostname 'docker' \
	--interactive \
	--tty \
	--volume "${HOME}"/src/:/root/src \
	--workdir '/root' \
	"${1}" \
	"${@:2}"
