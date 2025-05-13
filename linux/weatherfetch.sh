#!/usr/bin/env bash

# VARIABLES
location="${1}"
timestamp="$(date +'%Y-%m-%d %a %H:%M:%S')"

# HELPERS
#function row { printf -- '%s • %s\n' "${1}" "${2}"; }
function row { printf -- '%s: %s\n' "${1}" "${2}"; }
function separator { printf -- '—%.0s' {1..24}; printf '\n'; }
function show () { (set -x; "${@:?}"); }

# FETCH DATA
if command -v curl &> /dev/null; then
    function fetch_data { curl -s "wttr.in/${location}?format=${1}"; }
elif command -v wget &> /dev/null; then
	function fetch_data { wget -q -O- "wttr.in/${location}?format=${1}"; }
else
    echo "Install curl or wget to proceed. Exiting..."
    exit 1
fi
location="$(fetch_data "%l")"
weather="$(fetch_data "%C")"
temperature="$(fetch_data "%t")"
feelslike="$(fetch_data "%f")"
humidity="$(fetch_data "%h")"
wind="$(fetch_data "%w")"
rain="$(fetch_data "%p")"
uv_index="$(fetch_data "%u")"

# TEMPERATURE
temperature="${temperature//+/}"
feelslike="${feelslike//+/}"

# HUMIDITY
humidity_value="${humidity%%%}"
if (( humidity_value >= 0 && humidity_value <= 20 )); then
    humidity_category="Low"
elif (( humidity_value >= 21 && humidity_value <= 40 )); then
    humidity_category="Moderate"
elif (( humidity_value >= 41 && humidity_value <= 60 )); then
    humidity_category="High"
elif (( humidity_value >= 61 && humidity_value <= 80 )); then
    humidity_category="Very High"
elif (( humidity_value >= 81 && humidity_value <= 100 )); then
    humidity_category="Extreme"
else
    humidity_category="?"
fi

# RAIN
rain_value="${rain%mm}"
rain_value=$(echo "${rain_value} * 10" | bc)
rain_value=$(printf "%.0f" "${rain_value}")

if (( rain_value == 0 )); then
    rain_category="Nil"
elif (( rain_value >= 1 && rain_value <= 20 )); then
    rain_category="Light"
elif (( rain_value >= 21 && rain_value <= 100 )); then
    rain_category="Moderate"
elif (( rain_value >= 101 && rain_value <= 500 )); then
    rain_category="Heavy"
elif (( rain_value >= 501 )); then
    rain_category="Very Heavy"
else
    rain_category="?"
fi

# WIND
wind_new="${wind//[↗↘↙↖→←↑↓]/}"
wind_new="${wind_new//km\/h/kmph}"
case "${wind}" in
    *→*) wind_direction="East" ;;
    *←*) wind_direction="West" ;;
    *↑*) wind_direction="North" ;;
    *↓*) wind_direction="South" ;;
    *↗*) wind_direction="North East" ;;
    *↘*) wind_direction="South East" ;;
    *↙*) wind_direction="South West" ;;
    *↖*) wind_direction="North West" ;;
    *) wind_direction="${wind_new}" ;;
esac

# UV INDEX
if (( uv_index >= 0 && uv_index <= 2 )); then
    uv_category="Low"
elif (( uv_index >= 3 && uv_index <= 5 )); then
    uv_category="Moderate"
elif (( uv_index >= 6 && uv_index <= 7 )); then
    uv_category="High"
elif (( uv_index >= 8 && uv_index <= 10 )); then
    uv_category="Very High"
elif (( uv_index >= 11 )); then
    uv_category="Extreme"
else
    uv_category="?"
fi

# Begin script from here
#printf "%s\n" "${timestamp}"
# row "Source" "https://wttr.in"
row "Now" "${timestamp}"
# row "Location" "${location}"
row "Weather" "${weather}"
row "Temperature" "${temperature}"
row "FeelsLike" "${feelslike}"
row "Humidity" "${humidity} (${humidity_category})"
row "Rain" "${rain} (${rain_category})"
row "Wind" "${wind_new} (${wind_direction})"
row "UV Index" "${uv_index} (${uv_category})"
