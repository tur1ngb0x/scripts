#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

set -x
command docker --debug=true --log-level=debug container run \
    --interactive \
    --tty \
    --cpus 2 \
    --memory 2G \
    --memory-swap 0 \
    --user root \
    --hostname docker \
    --volume "${HOME}/src/:/root/src:ro" \
    --workdir /root \
    "${@}"
set +x
