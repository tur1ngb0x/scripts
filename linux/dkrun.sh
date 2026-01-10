#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

if command -v docker &>/dev/null; then
    TOOL="docker"
elif command -v podman &>/dev/null; then
    TOOL="podman"
else
    echo 'install docker/podman to continue'; exit
fi

set -x
command "${TOOL}" container run \
    --interactive \
    --tty \
    --cpus 2 \
    --memory 2G \
    --memory-swap 0 \
    --user root \
    --hostname docker \
    --volume "${HOME}/src/:/root/src:ro" \
    --workdir /root \
    "${@:?}"
set +x


# OLD
# set -x
# command "${TOOL}" --debug=true --log-level=debug container run \
#     --interactive \
#     --tty \
#     --cpus 2 \
#     --memory 2G \
#     --memory-swap 0 \
#     --user root \
#     --hostname docker \
#     --volume "${HOME}/src/:/root/src:ro" \
#     --workdir /root \
#     "${@:?}"
# set +x
