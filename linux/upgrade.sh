#!/usr/bin/env bash

# fail safe
set -euo pipefail
LC_ALL=C

# helpers
show() { printf '\033[7m # %s \033[0m\n' "${*}"; eval "${@:?}"; }
check() { command -v "${1:?}" &> /dev/null; }
[[ "$(id -ur)" -ne 0 ]] && ELEVATE="sudo"

# third party
check code    && show code --update-extensions
check pipx    && show pipx upgrade-all
check flatpak && show flatpak update --noninteractive
check snap    && show ${ELEVATE:-} snap refresh

# first party
check apt-get && show "${ELEVATE:-}" apt-get update && show "${ELEVATE:-}" apt-get dist-upgrade && exit
check dnf     && show "${ELEVATE:-}" dnf upgrade --refresh                                      && exit
check pamac   && show "${ELEVATE:-}" pamac upgrade --refresh                                    && exit
check pacman  && show "${ELEVATE:-}" pacman -Syyu --needed                                      && exit

# cleanup
unset ELEVATE
unset -f show
unset -f check
