#!/usr/bin/env bash

# function show { (set -x; "${@:?}"); }

set_display () {
    DISPLAY_INTERNAL="eDP"
    DISPLAY_EXTERNAL_1="HDMI-1"
    if [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
        if command -v xrandr &> /dev/null; then
            if xrandr | grep -qE "^(${DISPLAY_INTERNAL}-.*|${DISPLAY_EXTERNAL_1}-.*) connected" &> /dev/null; then
                # Turn off internal display
                show xrandr --output "${DISPLAY_INTERNAL}-1" --off
                # Set properties for external display
                show xrandr --output "${DISPLAY_EXTERNAL_1}" --auto --primary \
                    --set 'aspect ratio' '16:9' \
                    --set 'audio' 'on' \
                    --set 'Broadcast RGB' 'Full' \
                    --set 'Content Protection' 'Enabled' \
                    --set 'Colorspace' 'Default' \
                    --set 'HDCP Content Type' 'HDCP Type1' \
                    --set 'non-desktop' '0' \
                    --size '1920x1080' \
                    --refresh '60' \
                    --dpi '96'
            else
                echo 'Display data not available.'
            fi
        else
            printf "%s\n%s\n%s\n%s\n" \
                "xrandr not found" \
                "# apt install x11-xserver-utils" \
                "# dnf install xrandr" \
                "# pacman -S xorg-xrandr"
        fi
    else
        echo "${XDG_SESSION_TYPE} is not x11."
    fi
}

# begin script from here
xrandr --output HDMI-1 --set 'Broadcast RGB' 'Full' --size '1920x1080' --refresh '60' --dpi '96'
