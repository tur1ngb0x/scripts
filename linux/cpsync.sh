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
Uses 'rsync' to copy data and then performs 'sync' twice.

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <source> <destination>

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/} '/home/user/Downloads/arch-linux.iso' '/mnt/backup/iso'

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

rsync_flags=(--verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats)


show rsync "${rsync_flags[@]}" "${@}"

show sync

show sync

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
