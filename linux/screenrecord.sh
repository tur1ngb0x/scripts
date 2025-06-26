#!/usr/bin/env bash

[[ ${#} -gt 0 ]] && echo 'syntax: screenrecord.sh' && exit

ffmpeg \
	-loglevel verbose \
	-f 'x11grab' \
	-s '1920x1080' \
	-r '60' \
	-i "${DISPLAY}" \
	-c:v 'libx264rgb' \
	-preset 'ultrafast' \
	-crf '0' \
	"${HOME}/screenrecord.sh-$(date +%Y%m%S-%H%M%S).mp4"
