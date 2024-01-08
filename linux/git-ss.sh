#!/usr/bin/env bash

PROJECT_DIR="${HOME}/src"

for FOLDER in $(find "${PROJECT_DIR}" -type d -name '.git')
do
	PROJECT=$(sed 's/.git//g' <<< "${FOLDER}")
	tput rev; tput blink; tput bold; echo " ${PROJECT} "; tput sgr0
	git --git-dir="${PROJECT}"/.git --work-tree="${PROJECT}" status -s -b
done
