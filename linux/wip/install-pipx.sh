#!/usr/bin/env bash

export USE_EMOJI="0"

sudo apt-get install -y pipx || sudo dnf install -y pipx || sudo pacman -S --needed --noconfirm pipx

pipx install gallery-dl
pipx install glances
pipx install mycli
pipx install ps_mem
pipx install shellcheck-py
pipx install speedtest-cli
pipx install tldr
pipx install yt-dlp

unset USE_EMOJI
