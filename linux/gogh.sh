#!/usr/bin/env bash

GOGH_URL="https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh"

GOGH_TMP="$(mktemp /tmp/gogh.XXXXXX.sh)"


if command -v curl &> /dev/null; then
	curl -4 -o "${GOGH_TMP}" "${GOGH_URL}"
elif command -v wget &> /dev/null; then
	wget -4 -O "${GOGH_TMP}" "${GOGH_URL}"
else
	echo 'install curl or wget to proceed. Exiting...'; exit 1
fi

chmod +x "${GOGH_TMP}"

"${GOGH_TMP}"



# wget -4 -O /tmp/gogh.sh 'https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh'

# chmod +x /tmp/gogh.sh

# /tmp/gogh.sh
