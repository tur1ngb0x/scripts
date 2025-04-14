#!/usr/bin/env bash

function prompt_user {
    printf "${1}\n"
    read -p "Y/N: " -n 1 -r answer; echo
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        echo 'Exiting script...'
        exit
    fi
}

function check_commands {
  for cmd in "${@}"; do
    if command -v "${cmd}" &> /dev/null; then
        echo "${cmd} found in PATH"
    else
        echo "${cmd} not found in PATH"
        echo 'exiting script'
        exit
    fi
  done
}

# Example usage:
check_commands dconf uuidgen curl wget

prompt_user "Requirements: dconf-cli uuid-runtime\nProfile: default"

GOGH_URL="https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh"

GOGH_TMP="$(mktemp /tmp/gogh.XXXXXX.sh)"

if command -v curl &> /dev/null; then
    curl -s -4 -o "${GOGH_TMP}" "${GOGH_URL}"
elif command -v wget &> /dev/null; then
    wget -q -4 -O "${GOGH_TMP}" "${GOGH_URL}"
else
    echo 'install curl or wget to proceed. Exiting...'; exit 1
fi

chmod +x "${GOGH_TMP}"

"${GOGH_TMP}"

# wget -4 -O /tmp/gogh.sh 'https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh'

# chmod +x /tmp/gogh.sh

# /tmp/gogh.sh
