#!/usr/bin/env bash

function show() { (set -x; "${@:?}"); }

function usage {
    local Treset=$(tput sgr0)
    local Tbold=$(tput bold)
    local Titalic=$(tput sitm)
    local Tunderline=$(tput ul)
    local Treverse=$(tput rev)
    local Tdim=$(tput dim)
    cat << EOF

${Treverse}${Tbold} DESCRIPTION ${Treset}
Add your description here

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <arg1>

${Treverse}${Tbold} OPTIONS ${Treset}
Add your options here
--help, -help, help, --h, -h, h    show help

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/} <arg>

EOF
}

if [[ "${#}" -eq 0 ]]; then
    usage
    exit
fi
