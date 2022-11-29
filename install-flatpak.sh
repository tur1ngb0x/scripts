#!/usr/bin/env bash

flatpak --system remote-delete --force appcenter
flatpak --system remote-delete --force elementary
flatpak --system remote-delete --force fedora
flatpak --system remote-delete --force flathub
flatpak --system remote-delete --force flathub-beta
flatpak --system uninstall --all --force-remove --delete-data --assumeyes
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
