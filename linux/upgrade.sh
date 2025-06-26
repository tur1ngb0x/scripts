#!/usr/bin/env bash

# fail safes
LC_ALL=C
set -euo pipefail

# helpers
function show () {
    printf '\033[7m # %s \033[0m\n' "${*}"
    "${@:?}"
}
function check () {
    if ! command -v "${1}" &> /dev/null; then
        return 1
    fi
    return 0
}

# elevate
[[ "$(id -ur)" -ne 0 ]] && ELEVATE="sudo" || ELEVATE=""

printf '\033[7m %s \033[0m\n\n' "SYSTEM UPGRADER"
${ELEVATE} printf '%s\n' ''

# third party
check code    && show code --update-extensions
check pipx    && show pipx upgrade-all
check flatpak && show flatpak update --noninteractive
check snap    && show ${ELEVATE} snap refresh

# first party
check apt-get && show "${ELEVATE:-}" apt-get update && show "${ELEVATE}" apt-get dist-upgrade -y && exit
check dnf     && show "${ELEVATE:-}" dnf upgrade --refresh -y && exit
check pacman  && show "${ELEVATE:-}" pacman -Syyu --needed --noconfirm && exit
