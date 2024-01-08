#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <source> <destination>
Usage:
	${0##*/} /home/user/dotfiles /mnt/data/dotfiles
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

rsync_flags=( --verbose --recursive --no-inc-recursive --human-readable --progress --stats --compress-level=0 )

tput rev; tput blink; tput bold; echo ' copying files using rsync '; tput sgr0
rsync "${rsync_flags[@]}" "${@}"

tput rev; tput blink; tput bold; echo ' flushing buffers to disk '; tput sgr0
sync

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
