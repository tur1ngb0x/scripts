#!/usr/bin/env bash

set -e

usage(){
        cat << EOF
Usage:
    $(basename $0) <option>

Options:
    clean
    update
    upgrade
    search <package>
    install <package>
    remove <package>
EOF
}

if command -v apt-get &>/dev/null; then
    PKG="apt-get"
    echo 'apt-get detected'
elif command -v dnf &>/dev/null; then
    PKG="dnf"
    echo 'dnf detected'
elif command -v pacman &>/dev/null; then
    PKG="pacman"
    echo 'pacman detected'
else
    echo "No supported package manager found"
    exit 1
fi

case "${1}" in
    clean)
        [[ "$PKG" = "apt-get" ]] && sudo apt-get clean
        [[ "$PKG" = "dnf" ]] && sudo dnf clean all
        [[ "$PKG" = "pacman" ]] && sudo pacman -Scc
        ;;
    search)
        [[ "$PKG" = "apt-get" ]] && apt-cache search "${@:2}"
        [[ "$PKG" = "dnf" ]] && dnf search "${@:2}"
        [[ "$PKG" = "pacman" ]] && pacman -Ss "${@:2}"
        ;;
    install)
        [[ "$PKG" = "apt-get" ]] && sudo apt-get install "${@:2}"
        [[ "$PKG" = "dnf" ]] && sudo dnf install "${@:2}"
        [[ "$PKG" = "pacman" ]] && sudo pacman -S "${@:2}"
        ;;
    remove)
        [[ "$PKG" = "apt-get" ]] && sudo apt-get remove -y "${@:2}"
        [[ "$PKG" = "dnf" ]] && sudo dnf remove "${@:2}"
        [[ "$PKG" = "pacman" ]] && sudo pacman -R "${@:2}"
        ;;
    update)
        [[ "$PKG" = "apt-get" ]] && sudo apt-get update
        [[ "$PKG" = "dnf" ]] && sudo dnf check-update
        [[ "$PKG" = "pacman" ]] && sudo pacman -Sy
        ;;
    upgrade)
        [[ "$PKG" = "apt-get" ]] && sudo apt-get upgrade
        [[ "$PKG" = "dnf" ]] && sudo dnf upgrade
        [[ "$PKG" = "pacman" ]] && sudo pacman -Syu
        ;;
    *) usage; exit 1 ;;
esac
