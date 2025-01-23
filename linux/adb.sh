#!/usr/bin/env bash

adb stop-server
adb start-server

echo "Enter option:"
read -r option

case "${option}" in
    opt)    adb shell cmd package bg-dexopt-job ;;
    reboot) adb reboot ;;
    *)      echo "Invalid selection. Please enter a number between 1 and 5." ;;
esac
