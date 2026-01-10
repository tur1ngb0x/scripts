#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

if [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
	command loginctl lock-session && command sleep 5 && command xset dpms force off
fi

# command xset +dpms dpms 0 0 0
# command xset dpms force on
# command xset dpms force off
