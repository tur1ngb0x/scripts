#!/usr/bin/env bash

LC_ALL=C
set -euxo pipefail

dk_cpu="2"
dk_mem="2G"
dk_swp="0"
dk_usr="root"
dk_hst="docker"
dk_vol="${HOME}/src/:/root/src:ro"
dk_dir="/root"

dk_img="${1:?Enter image name}"; shift

docker --debug=true --log-level=debug container run \
    --interactive \
    --tty \
    --cpus "${dk_cpu}" \
    --memory "${dk_mem}" \
    --memory-swap "${dk_swp}" \
    --user "${dk_usr}" \
    --hostname "${dk_hst}" \
    --volume "${dk_vol}" \
    --workdir "${dk_dir}" \
    "${dk_img}" \
    "${@}"

unset dk_cpu
unset dk_mem
unset dk_swp
unset dk_usr
unset dk_hst
unset dk_vol
unset dk_dir
unset dk_img