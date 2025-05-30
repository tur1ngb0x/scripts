#!/usr/bin/env bash

usage() {
	cat <<EOF
DESCRIPTION
	Record the entire of currently active screen using ffmpeg.
SYNTAX
	$ ${0##*/} <framerate> <quality>
OPTIONS
	framerate - 0(worst) to 60(best)
	quality - 0(best) to 51(worst)
USAGE
	$ ${0##*/} 60 0
	$ ${0##*/} 60 25
	$ ${0##*/} 30 0
	$ ${0##*/} 60 25
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

# variables
rootdir="${HOME}/Videos/screenrecords"
file="${rootdir}/screenrecord-$(date +'%Y%m%d-%H%M%S').mp4"
log="/tmp/screenrecord-$(date +'%Y%m%d-%H%M%S').log"
framerate="${1}"
quality="${2}"

# create screenrecord directory
if [[ ! -d "${rootdir}" ]]; then
	mkdir -pv "${rootdir}" &>/dev/null
fi

# capture screenrecord
if command -v ffmpeg &> /dev/null; then
	(
		ffmpeg \
			-f 'x11grab' \
			-s '1920x1080' \
			-r "${framerate}" \
			-i "${DISPLAY}" \
			-c:v 'libx264rgb' \
			-preset 'ultrafast' \
			-crf "${quality}" \
			"${file}"
	) &>"${log}"
	echo -e "file\t${file}"
	echo -e "log\t${log}"
elif command -v notify-send &> /dev/null; then
	notify-send 'ffmpeg not found'
else
	echo 'ffmpeg not found'
	exit
fi

# xdg-open "${output_video}"
# xdg-open "${output_log}"

unset rootdir timestamp file log
