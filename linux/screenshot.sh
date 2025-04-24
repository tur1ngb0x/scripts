#!/usr/bin/env bash

# set variables
screenshot_tools=("gnome-screenshot" "xfce4-screenshooter" "spectacle" "scrot")
screenshot_tool=""
screenshot_dir="${HOME}/Pictures/screenshots"
screenshot_timestamp="$(date +'%Y%m%d-%H%M%S')"
screenshot_filestamp="ss-${screenshot_timestamp}"
screenshot_file="${screenshot_dir}/${screenshot_filestamp}.png"
#screenshot_log="${screenshot_dir}/${screenshot_filestamp}.log"
screenshot_log="/tmp/${screenshot_filestamp}.log"

# loop through the supported tools and find the first available one
for tool in "${screenshot_tools[@]}"; do
    if command -v "${tool}" &> /dev/null; then
        screenshot_tool="${tool}"
        break  # if tool is found, exit loop
    fi
done

# if screenshot tool was not found, exit the script
if [[ -z "${screenshot_tool}" ]]; then
    printf '%s\n%s\n' "No screenshot tool found." "Install any one from these: ${screenshot_tools[*]}"
    exit 1  # Exit with an error code
fi

# Set the screenshot command based on the available tool
case "${screenshot_tool}" in
    "gnome-screenshot")
        screenshot_command="gnome-screenshot --area --clipboard --file=\"${screenshot_file}\""
        ;;
    "xfce4-screenshooter")
        screenshot_command="xfce4-screenshooter --region --clipboard --save=\"${screenshot_file}\""
        ;;
    "spectacle")
        screenshot_command="spectacle --background --nonotify --region --copy-image --output=\"${screenshot_file}\""
        ;;
    "scrot")
        screenshot_command="scrot --quality 100 --select --freeze --file \"${screenshot_file}\""
        ;;
esac

# If screenshot directory does not exist, create it
if [[ ! -d "${screenshot_dir}" ]]; then
    mkdir -pv "${screenshot_dir}"
fi

# Capture screenshot
printf '%s\n' "${screenshot_command}"
(eval "${screenshot_command}") &> "${screenshot_log}"
printf 'file\t%s\nlog\t%s\n' "${screenshot_file}" "${screenshot_log}"
