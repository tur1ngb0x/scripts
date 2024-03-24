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

rsync_flags=( --verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats )

tput rev; echo ' copying files using rsync '; tput sgr0
rsync "${rsync_flags[@]}" "${@}"

tput rev; echo ' flushing buffers and writing data to disk (1/2) '; tput sgr0
sync && echo 'done'

tput rev; echo ' flushing buffers and writing data to disk (2/2) '; tput sgr0
sync && echo 'done'

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
