#!/usr/bin/env bash

usage()
{
	cat << EOF
Syntax:
	${0##*/} <target>
Usage:
	${0##*/} /home/user/Downloads
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

# set targets
target="${1}"
applications="${1}/applications"
archives="${1}/archives"
audios="${1}/audios"
diskimages="${1}/diskimages"
documents="${1}/documents"
pictures="${1}/pictures"
sourcecode="${1}/sourcecode"
torrents="${1}/torrents"
videos="${1}/videos"
zmisc="${1}/zmisc"

# exit if path is not a directory
if [[ ! -d "${target}" ]]; then
	echo 'target is not a directory'
	exit
fi

# create targets
mkdir -pv "${target}"
mkdir -pv "${applications}"
mkdir -pv "${archives}"
mkdir -pv "${audios}"
mkdir -pv "${diskimages}"
mkdir -pv "${documents}"
mkdir -pv "${pictures}"
mkdir -pv "${sourcecode}"
mkdir -pv "${torrents}"
mkdir -pv "${videos}"
mkdir -pv "${zmisc}"

# template
#tput rev; tput blink; tput bold; printf "%s\n" "template"; tput sgr0;
# find "${target}" -maxdepth 1 -type f \(\
# 	-iname "*.ext1" -o \
# 	-iname "*.ext2" -o \
# 	-iname "*.ext3" -o \
# 	-iname "*.extn" \
# \) -exec mv -v {} "${template}" \;

# apps
tput rev; tput blink; tput bold; printf "%s\n" "applications"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '\*.appimage' -o \
	-iname '\*.deb' -o \
	-iname '\*.exe' -o \
	-iname '\*.msi' -o \
	-iname '\*.rpm' \
\) -exec mv -v {} "${applications}" \;

# archives
tput rev; tput blink; tput bold; printf "%s\n" "archives"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.7z' -o \
	-iname '*.rar' -o \
	-iname '*.tar.gz' -o \
	-iname '*.tar.xz' -o \
	-iname '*.zip' \
\) -exec mv -v {} "${archives}" \;

# audios
tput rev; tput blink; tput bold; printf "%s\n" "audios"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.m4a' -o \
	-iname '*.mp3' -o \
	-iname '*.ogg' \
\) -exec mv -v {} "${audios}" \;

# disks
tput rev; tput blink; tput bold; printf "%s\n" "diskimages"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.img' -o \
	-iname '*.iso' -o \
	-iname '*.raw' \
\) -exec mv -v {} "${diskimages}" \;

# documents
tput rev; tput blink; tput bold; printf "%s\n" "documents"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.doc' -o \
	-iname '*.docx' -o \
	-iname '*.md' -o \
	-iname '*.odg' -o \
	-iname '*.odp' -o \
	-iname '*.ods' -o \
	-iname '*.odt' -o \
	-iname '*.pdf' -o \
	-iname '*.ppt' -o \
	-iname '*.pptx' -o \
	-iname '*.xls' -o \
	-iname '*.xlsx' \
\) -exec mv -v {} "${documents}" \;

# pictures
tput rev; tput blink; tput bold; printf "%s\n" "pictures"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.gif' -o \
	-iname '*.jpeg' -o \
	-iname '*.jpg' -o \
	-iname '*.png' \
\) -exec mv -v {} "${pictures}" \;

# source
tput rev; tput blink; tput bold; printf "%s\n" "sourcecode"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.json' -o \
	-iname '*.py' -o \
	-iname '*.sql' -o \
	-iname '*.txt' \
\) -exec mv -v {} "${sourcecode}" \;

# torrents
tput rev; tput blink; tput bold; printf "%s\n" "torrents"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.torrent'  \
\) -exec mv -v {} "${torrents}" \;

# videos
tput rev; tput blink; tput bold; printf "%s\n" "videos"; tput sgr0;
find -L "${target}" -maxdepth 1 -type f \(\
	-iname '*.mkv' -o \
	-iname '*.mp4' \
\) -exec mv -v {} "${videos}" \;

# cleanup other folders
tput rev; tput blink; tput bold; printf "%s\n" "zmisc"; tput sgr0;
find -L "${target}" -mindepth 1 -maxdepth 1 -type d -not \(\
	-path "${applications}" -o \
	-path "${archives}" -o \
	-path "${audios}" -o \
	-path "${diskimages}" -o \
	-path "${documents}" -o \
	-path "${pictures}" -o \
	-path "${sourcecode}" -o \
	-path "${torrents}" -o \
	-path "${videos}" -o \
	-path "${zmisc}" \
\) -exec mv -v {} "${zmisc}" \;
