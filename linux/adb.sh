#!/usr/bin/env bash

# Stop adb server
adb stop-server

# Read a value from the user
echo "Enter option:"
read -r option

# Use a case statement to handle different values
case "${option}" in
    opt)
        adb shell cmd package bg-dexopt-job
        ;;
	reboot)
		adb reboot
		;;
    *)
        echo "Invalid selection. Please enter a number between 1 and 5."
        ;;
esac
