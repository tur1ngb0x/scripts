#!/usr/bin/env bash

# if [[ ${#} -eq 0 ]] || [[ "${1}" =~ [[:space:]] ]]; then
#     cat << EOF
# Error:
# Invalid Input

# Syntax:
# weatherfetch.sh <location>

# Help:
# curl https://wttr.in/:help

# Docs:
# https://github.com/chubin/wttr.in/blob/master/README.md
# EOF
#     exit 1
# fi

# # VARIABLES
# location="${1}"

# # HELPERS
# function row () { printf -- '%12s : %s\n' "${1}" "${2}"; }
# function separator () { printf -- '—%.0s' {1..24}; printf '\n'; }
# function show () { (set -x; "${@:?}"); }
# if command -v curl &> /dev/null; then
#     function fetch_data () { command curl -s -L "wttr.in/${location}?format=${1}"; }
# elif command -v wget &> /dev/null; then
#     function fetch_data () { command wget -q -O- "wttr.in/${location}?format=${1}"; }
# else
#     echo 'curl/wget not found' && exit 1
# fi

# # GET DATA
# location="$(fetch_data '%l')"
# weather="$(fetch_data '%C')"
# temperature="$(fetch_data '%t')"
# feelslike="$(fetch_data '%f')"
# humidity="$(fetch_data '%h')"
# wind="$(fetch_data '%w')"
# rain="$(fetch_data '%p')"
# pressure="$(fetch_data '%P')"
# uv_index="$(fetch_data '%u')"

# # LOCATION
# location="${location//+/ }"

# # WEATHER
# weather="$(echo "$weather" | sed -r 's/(^|[[:space:],])([a-z])/\1\u\2/g')"

# # TEMPERATURE
# temperature="${temperature//+/}"
# temperature_value="${temperature//°C/}"
# if (( temperature_value < 0 )); then
#     temperature_category="Sub Zero"
# elif (( temperature_value >= 0 && temperature_value <= 10 )); then
#     temperature_category="Cold"
# elif (( temperature_value >= 11 && temperature_value <= 20 )); then
#     temperature_category="Cool"
# elif (( temperature_value >= 21 && temperature_value <= 30 )); then
#     temperature_category="Warm"
# elif (( temperature_value >= 31 && temperature_value <= 40 )); then
#     temperature_category="Hot"
# elif (( temperature_value > 40 )); then
#     temperature_category="Very Hot"
# else
#     temperature_category="?"
# fi

# # FEELS LIKE
# feelslike="${feelslike//+/}"
# feelslike_value="${feelslike//°C/}"
# if (( feelslike_value < 0 )); then
#     feelslike_category="Sub Zero"
# elif (( feelslike_value >= 0 && feelslike_value <= 10 )); then
#     feelslike_category="Cold"
# elif (( feelslike_value >= 11 && feelslike_value <= 20 )); then
#     feelslike_category="Cool"
# elif (( feelslike_value >= 21 && feelslike_value <= 30 )); then
#     feelslike_category="Warm"
# elif (( feelslike_value >= 31 && feelslike_value <= 40 )); then
#     feelslike_category="Hot"
# elif (( feelslike_value > 40 )); then
#     feelslike_category="Very Hot"
# else
#     feelslike_category="?"
# fi

# # HUMIDITY
# humidity_value="${humidity//%/}"
# if (( humidity_value >= 0 && humidity_value <= 20 )); then
#     humidity_category="Low"
# elif (( humidity_value >= 21 && humidity_value <= 40 )); then
#     humidity_category="Moderate"
# elif (( humidity_value >= 41 && humidity_value <= 60 )); then
#     humidity_category="High"
# elif (( humidity_value >= 61 && humidity_value <= 80 )); then
#     humidity_category="Very High"
# elif (( humidity_value >= 81 && humidity_value <= 100 )); then
#     humidity_category="Extreme"
# else
#     humidity_category="?"
# fi

# # RAIN
# #rain_value="${rain%mm}"
# rain_value="${rain//mm/}"
# rain_value=$(echo "${rain_value} * 10" | bc)
# rain_value=$(printf "%.0f" "${rain_value}")
# if (( rain_value == 0 )); then
#     rain_category="None"
# elif (( rain_value >= 1 && rain_value < 75 )); then
#     rain_category="Light"
# elif (( rain_value >= 75 && rain_value < 225 )); then
#     rain_category="Moderate"
# elif (( rain_value >= 225 && rain_value < 450 )); then
#     rain_category="Heavy"
# elif (( rain_value >= 450 )); then
#     rain_category="Very Heavy"
# else
#     rain_category="?"
# fi

# # PRESSURE
# pressure_value="${pressure%hPa}"
# if (( pressure_value < 1000 )); then
#     pressure_category="Very Low"
# elif (( pressure_value >= 1000 && pressure_value <= 1011 )); then
#     pressure_category="Low"
# elif (( pressure_value >= 1012 && pressure_value <= 1014 )); then
#     pressure_category="Normal"
# elif (( pressure_value >= 1015 && pressure_value <= 1025 )); then
#     pressure_category="High"
# elif (( pressure_value > 1025 )); then
#     pressure_category="Very High"
# else
#     pressure_category="?" # Fallback for unexpected or non-numeric input
# fi

# # WIND
# wind_value="${wind}"
# wind="${wind//[↗↘↙↖→←↑↓]/}"
# wind="${wind//km\/h/kmph}"
# case "${wind_value}" in
#     *→*) wind_direction="East" ;;
#     *←*) wind_direction="West" ;;
#     *↑*) wind_direction="North" ;;
#     *↓*) wind_direction="South" ;;
#     *↗*) wind_direction="North East" ;;
#     *↘*) wind_direction="South East" ;;
#     *↙*) wind_direction="South West" ;;
#     *↖*) wind_direction="North West" ;;
#     *) wind_direction="?" ;;
# esac

# # UV INDEX
# if (( uv_index >= 0 && uv_index <= 2 )); then
#     uv_category="Low"
# elif (( uv_index >= 3 && uv_index <= 5 )); then
#     uv_category="Moderate"
# elif (( uv_index >= 6 && uv_index <= 7 )); then
#     uv_category="High"
# elif (( uv_index >= 8 && uv_index <= 10 )); then
#     uv_category="Very High"
# elif (( uv_index >= 11 )); then
#     uv_category="Extreme"
# else
#     uv_category="?"
# fi



# function aqi () {
#     command curl -s -L 'https://www.iqair.com/india/maharashtra/pune/bhumkar-nagar-pune-iitm' -o /tmp/aqi
#     if grep -q 'Close your windows' /tmp/aqi; then
#         echo 'aqi bad'
#     fi
# }

# function weather_short () {
#     printf '%s : %s\n' "Now" "$(date +'%Y-%m-%d %a %H:%M:%S')"
#     printf '%s : %s\n' "Location" "$(curl -s -L "wttr.in/${1}?format=%l")"
#     printf '%s : %s\n' "Weather" "$(curl -s -L "wttr.in/${1}?format=%C")"
#     printf '%s : %s\n' "Temperature" "$(curl -s -L "wttr.in/${1}?format=%t")"
#     printf '%s : %s\n' "FeelsLike" "$(curl -s -L "wttr.in/${1}?format=%f")"
#     printf '%s : %s\n' "Humidity" "$(curl -s -L "wttr.in/${1}?format=%h")"
#     printf '%s : %s\n' "Rain" "$(curl -s -L "wttr.in/${1}?format=%p")"
#     printf '%s : %s\n' "Wind" "$(curl -s -L "wttr.in/${1}?format=%w")"
#     printf '%s : %s\n' "Pressure" "$(curl -s -L "wttr.in/${1}?format=%P")"
#     printf '%s : %s\n' "UV Index" "$(curl -s -L "wttr.in/${1}?format=%u")"
# }

# function main () {
#     (
#         row "Now" "$(date +'%Y-%m-%d %a %H:%M:%S')"
#         row "Location" "${location}"
#         row "Weather" "${weather}"
#         row "Temperature" "${temperature} (${temperature_category})"
#         row "FeelsLike" "${feelslike} (${feelslike_category})"
#         row "Humidity" "${humidity} (${humidity_category})"
#         row "Rain" "${rain} (${rain_category})"
#         row "Wind" "${wind} (${wind_direction})"
#         row "Pressure" "${pressure} (${pressure_category})"
#         row "UV Index" "${uv_index} (${uv_category})"
#     ) > /tmp/weatherfetch
#     command cat /tmp/weatherfetch
# }


# # begin script from here
# main "${@}"



# #####################################################################
# REWRITE
# #####################################################################
LC_ALL=C
export LC_ALL

function usage {
    cat << EOF
DESCRIPTION
    Show weather information for a specified location using wttr.in
SYNTAX
    $ ${0##*/} <option> <location>
OPTIONS
    -c    check requirements
    -h    show help
    -l    use long format (default)
    -s    use short format

USAGE
    $ ${0##*/} -l "Pune"
    $ ${0##*/} -s "Mumbai"
    $ ${0##*/} "London" # Defaults to long format
EOF
}

#######################################################################
# helpers
#######################################################################
function print_row { printf -- '%12s : %s\n' "${1}" "${2}"; }
function print_sep { printf -- '—%.0s' {1..30}; printf '\n'; }
function print_na { printf '%s' '?'; }
function check_cmd {
    cmdlist=(curl wget date) # Added date as it's used
    cmdyes=()
    cmdno=()

    for cmd in "${cmdlist[@]}"; do
        if command -v "${cmd}" &> /dev/null; then
            cmdyes+=("${cmd}")
        else
            cmdno+=("${cmd}")
        fi
    done

    printf '%s\n' "Requirements: ${cmdlist[*]}"

    if [ "${#cmdno[@]}" -eq 0 ]; then
        printf '%s\n' 'Status: Pass'
    else
        printf '%s\n' 'Status: Fail'
        printf '%s\n' "Found: ${cmdyes[*]}"
        printf '%s\n' "Missing: ${cmdno[*]}"
        cat << EOF
Debian/Ubuntu: apt install curl wget coreutils
RHEL/Fedora:   dnf install curl wget coreutils
Arch:          pacman -Syu curl wget coreutils
Alpine:        apk add     curl wget busybox
EOF
    fi
    # Exit if critical commands are missing
    if [[ " ${cmdno[*]} " =~ " curl " ]] && [[ " ${cmdno[*]} " =~ " wget " ]]; then
        exit 1
    fi
}

# Helper to fetch data from wttr.in
function fetch_wttr_data () {
    local format_string="${1}"
    local location="${2}"
    if command -v curl &> /dev/null; then
        command curl -s -L "wttr.in/${location}?format=${format_string}"
    elif command -v wget &> /dev/null; then
        command wget -q -O- "wttr.in/${location}?format=${format_string}"
    else
        print_na
    fi
}

#######################################################################
# get data
#######################################################################
function get_now {
    if command -v date &> /dev/null; then
        printf '%s' "$(date +'%Y-%m-%d %a %H:%M:%S')"
    else
        print_na
    fi
}

function get_location {
    local loc_raw
    loc_raw="$(fetch_wttr_data '%l' "${1}")"
    # Replace '+' with space for display
    printf '%s' "${loc_raw//+/ }"
}

function get_weather {
    local weather_raw
    weather_raw="$(fetch_wttr_data '%C' "${1}")"
    # Capitalize each word
    printf '%s' "$(echo "$weather_raw" | sed -r 's/(^|[[:space:],])([a-z])/\1\u\2/g')"
}

function get_temperature {
    local temp_raw
    temp_raw="$(fetch_wttr_data '%t' "${1}")"
    local temp_value="${temp_raw//°C/}"
    temp_value="${temp_value//+/}" # Remove leading '+' if present
    local category="?"

    if (( temp_value < 0 )); then
        category="Sub Zero"
    elif (( temp_value >= 0 && temp_value <= 10 )); then
        category="Cold"
    elif (( temp_value >= 11 && temp_value <= 20 )); then
        category="Cool"
    elif (( temp_value >= 21 && temp_value <= 30 )); then
        category="Warm"
    elif (( temp_value >= 31 && temp_value <= 40 )); then
        category="Hot"
    elif (( temp_value > 40 )); then
        category="Very Hot"
    fi
    printf '%s (%s)' "${temp_raw}" "${category}"
}

function get_feelslike {
    local feels_raw
    feels_raw="$(fetch_wttr_data '%f' "${1}")"
    local feels_value="${feels_raw//°C/}"
    feels_value="${feels_value//+/}" # Remove leading '+' if present
    local category="?"

    if (( feels_value < 0 )); then
        category="Sub Zero"
    elif (( feels_value >= 0 && feels_value <= 10 )); then
        category="Cold"
    elif (( feels_value >= 11 && feels_value <= 20 )); then
        category="Cool"
    elif (( feels_value >= 21 && feels_value <= 30 )); then
        category="Warm"
    elif (( feels_value >= 31 && feels_value <= 40 )); then
        category="Hot"
    elif (( feels_value > 40 )); then
        category="Very Hot"
    fi
    printf '%s (%s)' "${feels_raw}" "${category}"
}

function get_humidity {
    local humidity_raw
    humidity_raw="$(fetch_wttr_data '%h' "${1}")"
    local humidity_value="${humidity_raw//%/}"
    local category="?"

    if (( humidity_value >= 0 && humidity_value <= 20 )); then
        category="Low"
    elif (( humidity_value >= 21 && humidity_value <= 40 )); then
        category="Moderate"
    elif (( humidity_value >= 41 && humidity_value <= 60 )); then
        category="High"
    elif (( humidity_value >= 61 && humidity_value <= 80 )); then
        category="Very High"
    elif (( humidity_value >= 81 && humidity_value <= 100 )); then
        category="Extreme"
    fi
    printf '%s (%s)' "${humidity_raw}" "${category}"
}

function get_rain {
    local rain_raw
    rain_raw="$(fetch_wttr_data '%p' "${1}")"
    local rain_value="${rain_raw//mm/}"
    rain_value=$(echo "${rain_value} * 10" | bc 2>/dev/null) # Scale by 10 as per original script logic
    rain_value=$(printf "%.0f" "${rain_value}" 2>/dev/null) # Ensure integer

    local category="?"
    if [ -z "${rain_value}" ]; then # Handle cases where bc fails or input is not numeric
        category="?"
    elif (( rain_value == 0 )); then
        category="None"
    elif (( rain_value >= 1 && rain_value < 75 )); then
        category="Light"
    elif (( rain_value >= 75 && rain_value < 225 )); then
        category="Moderate"
    elif (( rain_value >= 225 && rain_value < 450 )); then
        category="Heavy"
    elif (( rain_value >= 450 )); then
        category="Very Heavy"
    fi
    printf '%s (%s)' "${rain_raw}" "${category}"
}

function get_wind {
    local wind_raw
    wind_raw="$(fetch_wttr_data '%w' "${1}")"
    local wind_display="${wind_raw//[↗↘↙↖→←↑↓]/}" # Remove direction symbols for display
    wind_display="${wind_display//km\/h/kmph}"

    local wind_direction="?"
    case "${wind_raw}" in
        *→*) wind_direction="East" ;;
        *←*) wind_direction="West" ;;
        *↑*) wind_direction="North" ;;
        *↓*) wind_direction="South" ;;
        *↗*) wind_direction="North East" ;;
        *↘*) wind_direction="South East" ;;
        *↙*) wind_direction="South West" ;;
        *↖*) wind_direction="North West" ;;
    esac
    printf '%s (%s)' "${wind_display}" "${wind_direction}"
}

function get_pressure {
    local pressure_raw
    pressure_raw="$(fetch_wttr_data '%P' "${1}")"
    local pressure_value="${pressure_raw%hPa}"
    local category="?"

    if (( pressure_value < 1000 )); then
        category="Very Low"
    elif (( pressure_value >= 1000 && pressure_value <= 1011 )); then
        category="Low"
    elif (( pressure_value >= 1012 && pressure_value <= 1014 )); then
        category="Normal"
    elif (( pressure_value >= 1015 && pressure_value <= 1025 )); then
        category="High"
    elif (( pressure_value > 1025 )); then
        category="Very High"
    fi
    printf '%s (%s)' "${pressure_raw}" "${category}"
}

function get_uv_index {
    local uv_raw
    uv_raw="$(fetch_wttr_data '%u' "${1}")"
    local uv_value="${uv_raw}"
    local category="?"

    if (( uv_value >= 0 && uv_value <= 2 )); then
        category="Low"
    elif (( uv_value >= 3 && uv_value <= 5 )); then
        category="Moderate"
    elif (( uv_value >= 6 && uv_value <= 7 )); then
        category="High"
    elif (( uv_value >= 8 && uv_value <= 10 )); then
        category="Very High"
    elif (( uv_value >= 11 )); then
        category="Extreme"
    fi
    printf '%s (%s)' "${uv_raw}" "${category}"
}

#######################################################################
# display data short format
#######################################################################
function fetch_short {
    local location="${1}"
    if [ -z "${location}" ]; then
        printf '%s\n' "Error: Location not specified for short format."
        usage
        exit 1
    fi

    cat <<-EOF
Location : $(get_location "${location}")
Weather : $(get_weather "${location}")
Temperature: $(get_temperature "${location}" | cut -d' ' -f1)
Humidity : $(get_humidity "${location}" | cut -d' ' -f1)
Rain : $(get_rain "${location}" | cut -d' ' -f1)
Wind : $(get_wind "${location}" | cut -d' ' -f1)
EOF
}

#######################################################################
# display data long format (default)
#######################################################################
function fetch_long {
    local location="${1}"
    if [ -z "${location}" ]; then
        printf '%s\n' "Error: Location not specified for long format."
        usage
        exit 1
    fi

    print_row 'Now'         "$(get_now)"
    print_row 'Location'    "$(get_location "${location}")"
    print_row 'Weather'     "$(get_weather "${location}")"
    print_row 'Temperature' "$(get_temperature "${location}")"
    print_row 'FeelsLike'   "$(get_feelslike "${location}")"
    print_row 'Humidity'    "$(get_humidity "${location}")"
    print_row 'Rain'        "$(get_rain "${location}")"
    print_row 'Wind'        "$(get_wind "${location}")"
    print_row 'Pressure'    "$(get_pressure "${location}")"
    print_row 'UV Index'    "$(get_uv_index "${location}")"
}

function main () {
    local option=""
    local location=""

    # Parse options and location
    while getopts ":hcs:l:" opt; do
        case "${opt}" in
            h)  usage; exit 0 ;;
            c)  check_cmd; exit 0 ;;
            s)  option="-s"; location="${OPTARG}"; break ;; # Short format with location
            l)  option="-l"; location="${OPTARG}"; break ;; # Long format with location
            \?) printf "Invalid option: -%s\n" "${OPTARG}" >&2; usage; exit 1 ;;
            :)  printf "Option -%s requires an argument.\n" "${OPTARG}" >&2; usage; exit 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    # If no options, assume default long format and treat first argument as location
    if [ -z "${option}" ] && [ -n "${1}" ]; then
        option="-l"
        location="${1}"
    elif [ -z "${option}" ] && [ -z "${1}" ]; then
        printf "Error: No location specified.\n" >&2
        printf "Type 'weatherfetch.sh -h' for more info.\n" >&2
        exit 1
    fi


    # Execute based on option
    case "${option}" in
        -s) fetch_short "${location}" ;;
        -l) fetch_long "${location}" ;;
        *)  # Should not happen if parsing is correct, but as a fallback
            printf "Error: Unhandled option or missing location.\n" >&2
            usage
            exit 1
            ;;
    esac
}

#######################################################################
# begin script from here
#######################################################################
main "${@}"
