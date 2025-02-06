#!/usr/bin/env bash

screenshot_dir="${HOME}/Pictures/screenshots"
timestamp="$(date +'%Y%m%d-%H%M%S')"
filestamp="ss-${timestamp}"
screenshot_file="${rootdir}/${filestamp}.png"
screenshot_log="${rootdir}/${filestamp}.log"

if [[ ! -d "${screenshot_dir}" ]]; then
	mkdir -pv "${screenshot_dir}"
fi

if [[ $(command -pv gnome-screenshot) ]]; then
    screenshot_command="gnome-screenshot --area --clipboard --file=\"${screenshot_file}\""
elif [[ $(command -pv xfce4-screenshooter) ]]; then
    screenshot_command="xfce4-screenshooter --region --clipboard --save=\"${screenshot_file}\""
elif [[ $(command -pv spectacle) ]]; then
    screenshot_command="spectacle --background --nonotify --region --copy-image --output=\"${screenshot_file}\""
elif [[ $(command -pv scrot) ]]; then
    screenshot_command="scrot --quality 100 --select --freeze \"${screenshot_file}\""
fi


if [[ -n "${screenshot_command}" ]]; then
    "${screenshot_command}" &> "${screenshot_log}"
    if [[ ! "${?}" -eq 0 ]]; then
        echo "Error capturing screenshot. Check ${screenshot_log}"
    fi
else
    echo "No screenshot utility found. Install"
fi

printf '\nfile\t%s\nlog\t%s\n' "${output}" "${log}"
