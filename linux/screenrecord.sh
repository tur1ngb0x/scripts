#!/usr/bin/env bash

#
# [[ ${#} -gt 0 ]] && echo 'syntax: screenrecord.sh' && exit
#
# ffmpeg \
# 	-loglevel verbose \
# 	-f 'x11grab' \
# 	-s '1920x1080' \
# 	-r '60' \
# 	-i "${DISPLAY}" \
# 	-c:v 'libx264rgb' \
# 	-preset 'ultrafast' \
# 	-crf '0' \
# 	"${HOME}/screenrecord.sh-$(date +%Y%m%S-%H%M%S).mp4"

if [[ $# -ne 2 ]]; then
	cat <<EOF
Usage:
$ screenrecord.sh <fps 0-60> <quality 0-51>

Examples:
$ screenrecord.sh 60 0  (60fps + best quality)
$ screenrecord.sh 15 51 (15fps + worst quality)
EOF
	exit
fi

fps="$1"
quality="$2"
output="$HOME/screenrecord-$(date +%Y%m%d-%H%M%S)-1920x1080-${fps}fps-${crf}crf.mp4"

ffmpeg \
    -loglevel 'quiet' \
    -f 'x11grab' \
    -s '1920x1080' \
    -r "${fps}" \
    -i "${DISPLAY}" \
    -c:v 'libx264rgb' \
    -preset 'ultrafast' \
    -crf "${quality}" \
    "${output}"


echo ''
echo '+ find $HOME -mindepth 1 -maxdepth 1 -name "screenrecord*.mp4" | sort'
find $HOME -mindepth 1 -maxdepth 1 -name "screenrecord*.mp4" | sort
