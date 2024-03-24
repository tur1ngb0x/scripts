#!/usr/bin/env bash

# usage function
usage()
{
	cat << EOF
Syntax:
	${0##*/} <media_type> <media_mode> <media_url>
Options:
	media_type:
		video (v), audio (a)
	media_mode:
		single (s), playlist (p)
	media_url:
		remote url (youtube, soundcloud)
Usage:
	audio single:
		${0##*/} v s 'https://youtube.com/watch?v=dQw4w9WgXcQ'
	video playlist:
		${0##*/} a p 'https://youtube.com/playlist?list=PLr5RRQC6c-2gwyPr8JaBnEiK_xARWTflv'
EOF
}

# exit if less than 3 arguments
if [[ "${#}" -le 3 ]]; then
	usage
	exit
fi

# video / audio
media_type="${1}"

# single / playlist
media_mode="${2}"

# remote url
media_url="${3}"

# local folder
media_dir="${HOME}/Downloads/${0##*/}/"

# download function
md(){ yt-dlp --concurrent-fragments 4 --console-title --force-ipv4 --ignore-errors --no-config --no-mtime --prefer-ffmpeg --restrict-filenames --verbose --format 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "${@}"; }

# create local folder0
mkdir -pv "${media_dir}"
pushd "${media_dir}" || exit

# switch case
case "${media_type}" in
	v)	case "${media_mode}" in
			s) md '--output' '%(title)s.%(ext)s' "${media_url}" ;;
			p) md '--output' '%(playlist)s/%(playlist_index)03d_%(title)s.%(ext)s' "${media_url}" ;;
			*) usage ;;
		esac ;;
	a)	case "${media_mode}" in
			s) md '--extract-audio' '--audio-format' 'mp3' '--audio-quality' '0' '--output' '%(title)s.%(ext)s' "${media_url}" ;;
			p) md '--extract-audio' '--audio-format' 'mp3' '--audio-quality' '0' '--output'  '%(playlist)s/%(playlist_index)03d_%(title)s.%(ext)s' "${media_url}" ;;
			*) usage ;;
		esac ;;
	*)	usage ;;
esac

popd || exit
