#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

if [[ $# -ne 0 ]]; then
    command builtin printf 'usage: %s\n' "${0##*/}"
    builtin exit
fi

if [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
	command scrot -s -f -q 100 -Z 0 -o /tmp/ss.png
	command xclip -sel clip -t image/png -i /tmp/ss.png
	command install -v -D -o "${USER}" -g "${USER}" -m 755 /tmp/ss.png "${HOME}/Pictures/ss_$(command date +%Y%m%d-%H%M%S).png"
	builtin exit
fi

if [[ "${XDG_SESSION_TYPE}" == 'wayland' ]]; then
	command slurp -d | command grim -q 100 -l 0 -g - /tmp/ss.png
	command wl-copy < /tmp/ss.png
	command install -v -D -o "${USER}" -g "${USER}" -m 755 /tmp/ss.png "${HOME}/Pictures/ss_$(command date +%Y%m%d-%H%M%S).png"
	builtin exit
fi
