#!/usr/bin/env bash


bloat_frontend_uninstall=( )

bloat_backend_uninstall=( )

bloat_frontend_disable=( )

bloat_backend_disable=( )

# uninstall bloat
for pkg in "${bloat_frontend_uninstall[@]}"; do
	echo -e "\nun-installing: ${pkg}"
	adb shell pm uninstall --user 0 "${pkg}"
done
for pkg in "${bloat_backend_uninstall[@]}"; do
	echo -e "\nun-installing: ${pkg}"
	adb shell pm uninstall --user 0 "${pkg}"
done

# disable bloat
for pkg in "${bloat_frontend_disable[@]}"; do
	echo -e "\ndis-abling ${pkg}"
	adb shell pm disable-user --user 0 "${pkg}"
done
for pkg in "${bloat_backend_disable[@]}"; do
	echo -e "\ndis-abling ${pkg}"
	adb shell pm disable-user --user 0 "${pkg}"
done


# reinstall everything
for pkg in $(adb shell "(pm list packages -u && pm list packages) | sed 's/^package://' | sort | uniq -u"); do
	echo -e "\nre-installing: ${pkg}"
	adb shell "cmd package install-existing ${pkg}"
 done

for pkg in $(adb shell "pm list packages -d | sed 's/^package://' | sort | uniq -u"); do
	echo -e "\nre-enabling ${pkg}"
	adb shell "pm enable --user 0 ${pkg}"
done
