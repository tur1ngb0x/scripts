#!/usr/bin/env bash

function header	{ printf "\e[7m %s \e[0m \n" "${1}"; }

header 'creating /sdcard folders'
for folder in Archives Apps Documents Download Music Pictures Videos; do
	mkdir -pv /sdcard/"${folder}"
done

header 'moving archives'
for ext in 7z rar zip; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Archives \;
done

header 'moving apps'
for ext in aab apk xapk; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Apps \;
done

header 'moving documents'
for ext in doc docx pdf xls xlsx pptx ppt; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Documents \;
done

header 'moving pictures'
for ext in jpg jpeg gif bmp png webp jpg heic; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Pictures \;
done

header 'moving music'
for ext in flac m4a mp3 ogg; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Music \;
done

header 'moving videos'
for ext in avi mkv mp4 webm; do
	find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Videos \;
done

header 'finding thumbnail cache'
for folder in '.thumbnails'; do
	find /sdcard/ -type d -name "${folder}" 2>/dev/null | sed "s|^|'|;s|$|'|"
done

header 'finding trashed files'
for file in '.trashed-'; do
	find /sdcard/ -type f -name "${file}*" 2>/dev/null | sed "s|^|'|;s|$|'|"
done

# <FIND> | -exec rm {} \;
