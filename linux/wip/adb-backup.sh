#!/usr/bin/env bash

# wait for device
adb kill-server
adb wait-for-any-device
adb devices -l

device="$(adb shell getprop ro.product.device)"
version="A$(adb shell getprop ro.build.version.release)"
timestamp="$(date +%Y%m%d-%a-%H%M%S-%Z)"
template="${device}-${version}-${timestamp}"
backupdir="${HOME}/backups/android/${template}"
echo "Backup saved at ${backupdir}"

# backup folders
mkdir -pv "${backupdir}"
pushd "${backupdir}" || exit
adb pull -a "/sdcard/Android/media/com.whatsapp/WhatsApp"
adb pull -a "/sdcard/DCIM"
adb pull -a "/sdcard/Documents"
adb pull -a "/sdcard/Download"
adb pull -a "/sdcard/Movies"
adb pull -a "/sdcard/Music"
adb pull -a "/sdcard/Pictures"
adb pull -a "/sdcard/Ringtones"
adb pull -a "/sdcard/Videos"
popd || exit

# open backup
xdg-open "${backupdir}"
