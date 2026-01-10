#!/usr/bin/env bash

LC_ALL=C
set -euxo pipefail

# reset terminal
reset

# install dependencies
sudo pacman --sync --needed git base-devel

# remove existing pikaur directory
sudo rm -fr /tmp/pikaur

# get pikaur source
git clone --ipv4 --depth=1 https://aur.archlinux.org/pikaur.git /tmp/pikaur

# move into pikaur directory
pushd /tmp/pikaur

# disable lto and debug flags
builtin printf '%s\n' 'OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug !lto)' >| /tmp/makepkg.conf
install -v -D /tmp/makepkg.conf "${HOME}"/.config/pacman/makepkg.conf

# remove existing pikaur binary
# [[ -f /usr/bin/pikaur ]] && sudo pacman --remove --nosave --recursive --noconfirm pikaur

# compile pikaur
makepkg --cleanbuild --clean --syncdeps --install --force --rmdeps --needed --noconfirm

# install pacman-static
# pikaur -S --noedit --nodiff --noconfirm pacman-static
wget -4O /tmp/pacman-static 'https://pkgbuild.com/~morganamilo/pacman-static/x86_64/bin/pacman-static'
sudo install -v -D -m 0755 -o root -g root /tmp/pacman-static /usr/bin/pacman-static

# install pikaur-static
# pikaur -S --noedit --nodiff --noconfirm pikaur-static

set +euxo pipefail
