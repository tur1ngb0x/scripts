#!/usr/bin/env bash

usage() {
	cat << EOF

Description:
    Uses 'rsync' to copy data and then performs 'sync' twice.

Syntax:
    $ ${0##*/} <source> <destination>

Usage:
    $ ${0##*/} /home/user/Downloads/arch-linux.iso /mnt/backup/iso
    $ ${0##*/} /etc/skel/. "${HOME}"

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

rsync_flags=(--verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats)

echo ' copying files using rsync '
rsync "${rsync_flags[@]}" "${@}"

echo ' flushing buffers and writing data to disk (1/2) '
sync && echo 'done'

echo ' flushing buffers and writing data to disk (2/2) '
sync && echo 'done'

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
