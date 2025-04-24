#!/usr/bin/env bash

function show() { (set -x; "${@:?}"); }

function usage {
	cat << EOF
DESCRIPTION
    Uses 'rsync' to copy data and then performs 'sync' twice.
SYNTAX
    $ ${0##*/} <source> <destination>
USAGE
    $ ${0##*/} '/home/user/Downloads/arch-linux.iso' '/mnt/backup/iso'
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

rsync_flags=(--verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats --ipv4)

show rsync "${rsync_flags[@]}" "${@}"

if [ "${?}" -eq 0 ]; then
	show sync
	show sync
fi

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
