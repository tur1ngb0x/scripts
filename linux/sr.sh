#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <framerate> <quality>
Usage:
	${0##*/} 60 0
	${0##*/} 30 21
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

framerate="{1}"
timestamp="$(date +'%Y%m%d_%H%M%S')"
output_video="${HOME}/screenrecord_${timestamp}.mp4"
output_log="/tmp/screenrecord_${timestamp}.log"

(\
	ffmpeg \
	-f 'x11grab' \
	-s '1920x1080' \
	-r "${1}" \
	-i "${DISPLAY}" \
	-c:v 'libx264rgb' \
	-preset 'ultrafast' \
	-crf "${2}" \
	"${output_video}" \
) &> "${output_log}"

# xdg-open "${output_video}"
# xdg-open "${output_log}"
