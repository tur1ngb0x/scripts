#!/bin/env bash

# Enable debug tracing if DEBUG=1 is set
[ "${DEBUG}" = 1 ] && (set -x &>/dev/null)

# Detect supported package manager: apt-get, dnf, or pacman
detect_pm() {
    for cmd in apt-get dnf pacman; do
        if command -v "${cmd}" &>/dev/null; then
            echo "${cmd}"
            return 0
        fi
    done
    echo "Error: No supported package manager found (apt-get, dnf, pacman)." >&2
    exit 1
}

PM="$(detect_pm)"

# Help/Usage
function usage () {
    cat << EOF
Usage:
    pkg.sh <command> <pkg>

Commands:
    help            Show this help
    clean           Remove package cache
    install <pkg>	Install package
    remove <pkg>    Remove package and config
    refresh         Refresh package metadata
    upgrade         Upgrade all packages
EOF
}

# Main command dispatch
case "${1}" in
    help) usage ;;

    install)
        pkg="${2}"
	    [ -z "${pkg}" ] && usage && exit 1
        case "${PM}" in
            apt-get) sudo apt-get install -y "${pkg}" ;;
            dnf) sudo dnf install -y "${pkg}" ;;
            pacman) sudo pacman -S --noconfirm "${pkg}" ;;
        esac
        ;;

    remove)
        pkg="${2}"
	    [ -z "${pkg}" ] && usage && exit 1
        case "$PM" in
            apt-get) sudo apt-get purge --autoremove "$pkg" ;;
            dnf) sudo dnf remove "$pkg" ;;
            pacman) sudo pacman -Rns "$pkg" ;;
        esac
        ;;

    refresh)
        case "$PM" in
            apt-get) sudo apt-get update ;;
            dnf) sudo dnf makecache ;;
            pacman) sudo pacman -Sy ;;
        esac
        ;;

    clean)
        case "$PM" in
            apt-get) sudo apt-get clean ;;
            dnf) sudo dnf clean all ;;
            pacman) sudo pacman -Scc --noconfirm ;;
        esac
        ;;

    upgrade)
        case "$PM" in
            apt-get) sudo apt-get upgrade -y ;;
            dnf) sudo dnf upgrade -y ;;
            pacman) sudo pacman -Syu --noconfirm ;;
        esac
        ;;

    *)
        usage
        exit 1
        ;;
esac
