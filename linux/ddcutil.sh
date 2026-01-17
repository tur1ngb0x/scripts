#!/usr/bin/env bash

# Enforce POSIX locale
export LC_ALL='C'

# Enforce bash strict mode
set -euxo pipefail

# Hard code PATH
export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin'

function usage () {
    builtin echo "usage:"
    builtin echo "  ddcutil.sh"
    builtin echo "  ddcutil.sh <brightness 0-100>"
}

function set_by_time () {
    current_time="$(command date '+%H%M')"

    if builtin test "${current_time}" -ge 630 && builtin test "${current_time}" -le 1829; then
        command ddcutil setvcp 10 100
    else
        command ddcutil setvcp 10 10
    fi
}

function set_by_brightness () {
    brightness="${1}"

    if command printf '%s\n' "${brightness}" | command grep -Eq '^[0-9]+$' && \
       builtin test "${brightness}" -ge 0 && builtin test "${brightness}" -le 100; then
        command ddcutil setvcp 10 "${brightness}"
    else
        usage
        return 1
    fi
}

function main () {
    if builtin test "${#}" -eq 0; then
        set_by_time
    elif builtin test "${#}" -eq 1; then
        set_by_brightness "${1}"
    else
        usage
        return 1
    fi
}

main "${@}"
