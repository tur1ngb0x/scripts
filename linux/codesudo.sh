#!/usr/bin/env bash

function usage {
    cat << EOF
DESCRIPTION
Open any file or folder as superuser using VS Code.

SYNTAX
$ ${0##*/} <file/folder>

USAGE
$ ${0##*/} /etc/default/grub
$ ${0##*/} /etc/sudoers.d/
EOF
}

if [[ "${#}" -eq 0 ]]; then
    usage
    exit
fi

function show { (set -x; "${@:?}"); }

# tput rev
# printf '%s\n' "opening ${*} with $(which code) as superuser"
# tput sgr0

# sudo code \
# 	--disable-chromium-sandbox \
# 	--disable-extensions \
# 	--disable-gpu \
# 	--disable-lcd-text \
# 	--locale en \
# 	--no-sandbox \
# 	--reuse-window \
# 	--sync off \
# 	--user-data-dir /tmp \
# 	"${@}"


TMPCODE="/tmp/vscode-sudo"

show mkdir -p "${TMPCODE}"

show command sudo --reset-timestamp bash -c "command code \
--disable-chromium-sandbox \
--disable-extensions \
--disable-gpu \
--disable-lcd-text \
--locale en \
--no-sandbox \
--reuse-window \
--sync off \
--user-data-dir ${TMPCODE} \
${@}
"
