#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <url>
Usage:
	${0##*/} https://www.youtube.com/watch?v=dQw4w9WgXcQ
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

mkdir -pv "${HOME}/Music/"

pushd "${HOME}/Music/" || exit

yt-dlp \
	--console-title \
	--force-ipv4 \
	--ignore-errors \
	--no-cache-dir \
	--no-config \
	--no-exec \
	--no-mtime \
	--no-sponsorblock \
	--prefer-ffmpeg \
	--restrict-filenames \
	--verbose \
	--extract-audio \
	--audio-format 'mp3' \
	--audio-quality 0 \
	--output '%(playlist)s/%(playlist_index)03d_%(title)s.%(ext)s' \
	"${@}"

#--split-chapters

popd || exit

ls "${HOME}/Music/"

find "${HOME}/Music/" -type f
