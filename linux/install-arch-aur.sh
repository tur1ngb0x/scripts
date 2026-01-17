#!/usr/bin/env bash

LC_ALL=C
set -euxo pipefail

sudo pacman --verbose --sync --needed --noconfirm git base-devel

sudo rm --verbose --force --recursive /tmp/pikaur

git clone --verbose --ipv4 --depth=1 https://aur.archlinux.org/pikaur.git /tmp/pikaur

pushd /tmp/pikaur

builtin printf '%s\n' 'OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug !lto)' >| /tmp/makepkg.conf

install --verbose -D /tmp/makepkg.conf "${HOME}"/.config/pacman/makepkg.conf

sudo pacman --remove --nosave --recursive pikaur

makepkg --cleanbuild --clean --syncdeps --install --force --rmdeps --needed --noconfirm

#/usr/bin/pikaur --color=always --verbose --noconfirm --sync --noedit --nodiff brave-bin ente-auth-bin bitwarden-bin

#wget -4O /tmp/pacman-static 'https://pkgbuild.com/~morganamilo/pacman-static/x86_64/bin/pacman-static'
#sudo install -v -D -m 0755 -o root -g root /tmp/pacman-static /usr/bin/pacman-static
