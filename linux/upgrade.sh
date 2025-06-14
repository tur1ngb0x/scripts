#!/usr/bin/env bash

# fail safes
LC_ALL=C
set -euo pipefail

# helpers
function show ()    { printf '\033[7m # %s \033[0m\n' "${*}"; "${@:?}"; }
function check ()   { command -v "${1}" &> /dev/null; }

# elevate
[[ "$(id -ur)" -eq 0 ]] && ELEVATE="" || ELEVATE="sudo"

"${ELEVATE}" echo -e '\n\n\nSYSTEM UPGRADER\n'

# third-party
check code    && show code --update-extensions
check pipx    && show pipx upgrade-all
check flatpak && show flatpak update --noninteractive -y
check snap    && show "${ELEVATE}" snap refresh

# first party
check apt-get && show "${ELEVATE}" apt-get update && show "${ELEVATE}" apt-get dist-upgrade -y && exit
check dnf     && show "${ELEVATE}" dnf upgrade --refresh -y && exit
check pacman  && show "${ELEVATE}" pacman -Syyu --needed --noconfirm && exit
