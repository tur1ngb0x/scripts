#!/usr/bin/env bash

# Set variables
location="${1}"
timestamp="$(date +'%Y-%m-%d %a %H:%M:%S')"

# Function to fetch data
# Function to fetch data
if command -v curl &> /dev/null; then
    fetch_data() { curl -s "wttr.in/${location}?format=${1}"; }
elif command -v wget &> /dev/null; then
	fetch_data() { wget -q -O- "wttr.in/${location}?format=${1}"; }
else
    echo "Install curl or wget to proceed. Exiting..."
    exit 1
fi

# Function to format output
row () { printf -- '%s • %s\n' "${1}" "${2}"; }
separator () { printf -- '—%.0s' {1..24}; printf '\n'; }

# Fetch each data row separately
location=$(fetch_data "%l")
weather=$(fetch_data "%C")
temperature=$(fetch_data "%t")
feelslike=$(fetch_data "%f")
humidity=$(fetch_data "%h")
wind=$(fetch_data "%w")
rain=$(fetch_data "%p")
uv_index=$(fetch_data "%u")

# Remove + sign from temperature and feelslike
temperature="${temperature//+/}"
feelslike="${feelslike//+/}"

# Remove wind direction symbols
wind_new="${wind//[↗↘↙↖→←↑↓]/}"

# Replace km/h with kmph
wind_new="${wind_new//km\/h/kmph}"

# Assign wind direction
case "$wind" in
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

# Categorize UV Index
if (( uv_index >= 0 && uv_index <= 2 )); then
    uv_category="Low"
elif (( uv_index >= 3 && uv_index <= 5 )); then
    uv_category="Moderate"
elif (( uv_index >= 6 && uv_index <= 7 )); then
    uv_category="High"
elif (( uv_index >= 8 && uv_index <= 10 )); then
    uv_category="Very High"
else
    uv_category="Extreme"
fi

# Begin script from here
printf "**%s**\n" "${timestamp}"
row "Location" "${location}"
row "Weather" "${weather}"
row "Temp" "${temperature} (${feelslike})"
row "Humidity" "${humidity}"
row "Rain" "${rain}"
row "Wind" "${wind_new} (${wind_direction})"
row "UV Index" "${uv_index} (${uv_category})"
