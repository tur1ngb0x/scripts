#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    cat << EOF
Installed Fonts:
$(command -p find "${HOME}/.local/share/fonts" -type f -iname "*nerdfontmono-regular*" 2>/dev/null | command -p sort 2>/dev/null)

Available Fonts:
https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/

Usage:
$ nerdfont.sh <fontname>
EOF
    exit
else
    { builtin set -euxo pipefail; } &>/dev/null
    command -p wget --quiet --show-progress --output-document="/tmp/${1}.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${1}.tar.xz"
    command -p mkdir --parents "${HOME}/.local/share/fonts/${1}"
    command -p tar --file "/tmp/${1}.tar.xz" --extract --xz --wildcards --no-anchored --overwrite --directory="${HOME}/.local/share/fonts/${1}" '*NerdFontMono-*'
    command -p rm --recursive --force /home/user/.cache/fontconfig/ && command -p fc-cache --really-force
    { builtin set +euxo pipefail; } &>/dev/null
    command -p find "${HOME}/.local/share/fonts" -type f -iname "*nerdfontmono-regular*" | command -p sort
fi
