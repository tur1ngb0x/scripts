#!/bin/sh

detect_pm() {
    for cmd in apt-get dnf pacman; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "${cmd}"
            return 0
        fi
    done
    echo "Could not detect apt-get, dnf, or pacman. Exiting..."
    exit 1
}

PM=$(detect_pm)

usage() {
    cat << EOF

Description:
    A POSIX wrapper for apt-get, dnf, pacman

Usage:
    pkg.sh <command> <pkg>

Commands:
    help             Show this help
    clean            Remove package cache
    install <pkg>    Install package(s)
    remove <pkg>     Remove package(s) and config
    refresh          Refresh package metadata
    upgrade          Upgrade all packages
EOF
}

main() {
    case "$1" in
        help)               usage ;;
        install)
            pkg="$2"; [ -z "$pkg" ] && usage && exit 1
            case "$PM" in
                apt-get)    sudo apt-get install "$pkg" ;;
                dnf)        sudo dnf install "$pkg" ;;
                pacman)     sudo pacman -Syu "$pkg" ;;
            esac ;;
        remove)
            pkg="$2"; [ -z "$pkg" ] && usage && exit 1
            case "$PM" in
                apt-get)    sudo apt-get purge --autoremove "$pkg" ;;
                dnf)        sudo dnf remove "$pkg" ;;
                pacman)     sudo pacman -Rns "$pkg" ;;
            esac ;;
        refresh)
            case "$PM" in
                apt-get)    sudo apt-get update ;;
                dnf)        sudo dnf makecache ;;
                pacman)     sudo pacman -Sy ;;
            esac ;;
        clean)
            case "$PM" in
                apt-get)    sudo apt-get clean ;;
                dnf)        sudo dnf clean all ;;
                pacman)     sudo pacman -Scc ;;
            esac ;;
        upgrade)
            case "$PM" in
                apt-get)    sudo apt-get upgrade ;;
                dnf)        sudo dnf upgrade ;;
                pacman)     sudo pacman -Syu ;;
            esac ;;
        *)                  usage && exit 1 ;;
    esac
}

main "$@"
