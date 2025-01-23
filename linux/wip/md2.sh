#!/usr/bin/env bash

# usage function
usage()
{
	cat << EOF
Syntax:
	${0##*/} <media_type> <media_url>
Options:
	media_type:
		audio single - as
		audio playlist - ap
		video single - vs
		video playlist - vp
	media_url: remote http url
Usage:
	${0##*/} vs 'https://youtube.com/watch?v=dQw4w9WgXcQ'
	${0##*/} ap 'https://youtube.com/playlist?list=PLr5RRQC6c-2gwyPr8JaBnEiK_xARWTflv'
EOF
}

# if arguments are not provided, exit
if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

# if yt-dlp not found, exit
if [[ ! $(command -v yt-dlp) ]]; then
	echo 'yt-dlp not found in PATH'
	exit
fi

# variables
media_type="${1}"
media_url="${2}"
media_dir="${HOME}/Downloads/${0##*/}/"

# enable aliases
shopt -s expand_aliases

# aliases
alias flags_common="yt-dlp --concurrent-fragments 4 --console-title --force-ipv4 --ignore-errors --no-config --no-mtime --prefer-ffmpeg --restrict-filenames --verbose"
alias flags_audio="--extract-audio --audio-format mp3 --audio-quality 0"
alias flags_video="--format bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
alias flags_single="--output %(title)s.%(ext)s"
alias flags_playlist="--output %(playlist)s/%(playlist_index)03d_%(title)s.%(ext)s"

# create and move into working directory
mkdir -pv "${media_dir}"
pushd "${media_dir}" || exit

# download media
case "${media_type}" in
	as)	flags_common flags_audio flags_output_single		"${media_url}" ;;
	ap) flags_common flags_audio flags_output_playlist	"${media_url}" ;;
	vs)	flags_common flags_video flags_output_single		"${media_url}" ;;
	vp) flags_common flags_video flags_output_playlist	"${media_url}" ;;
	*)	usage ;;
esac

# come out from working directory
popd || exit

# disable aliases
shopt -u expand_aliases
