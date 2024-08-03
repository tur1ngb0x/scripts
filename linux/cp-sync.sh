#!/usr/bin/env bash

usage()
{
	cat << EOF
Description:
	Copies files and folders using rsync and then performs sync operation.
Syntax:
	$ ${0##*/} <source> <destination>
Usage:
	$ ${0##*/} /home/user/dotfiles /mnt/data/dotfiles
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

if [[ $(command -v rsync) ]]; then
	rsync_flags=( --verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats )
	echo ' copying files using rsync '
	rsync "${rsync_flags[@]}" "${@}"
	echo ' flushing buffers and writing data to disk (1/2) '
	sync && echo 'done'
	echo ' flushing buffers and writing data to disk (2/2) '
	sync && echo 'done'
else
	echo 'rsync is not installed'
	exit
fi

# watch -c -t -n1 'grep -iE "(dirty|write|writeback|writebacktmp)" /proc/meminfo; echo; echo; for i in /sys/block/*; do awk "{ print \"$i: \"  \$9 }" "$i/stat"; done'
