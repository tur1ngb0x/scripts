#!/usr/bin/env bash

# <FIND> | -exec rm -frv {} \;
# du -sh /path

function header	{ printf "\e[7m %s \e[0m \n" "${1}"; }

header 'creating /sdcard folders'
for folder in Archives Apps Code Documents Download Music Pictures Videos; do
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

header 'moving code'
for ext in bin csv json py sql torrent; do
    find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Code \;
done

header 'moving documents'
for ext in doc docx pdf ppt pptx xls xlsx; do
    find /sdcard/Download -type f -name "*.${ext}" -exec mv -fv {} /sdcard/Documents \;
done

header 'moving pictures'
for ext in bmp gif heic jpg jpeg png webp; do
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

header 'finding cache files'
for folder in '.thumbnails' '.trashed-'; do
    (find /sdcard/ -type d -name "${folder}" 2>/dev/null) | sed "s|^|'|;s|$|'|";
done
