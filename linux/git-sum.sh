#!/usr/bin/env bash

# set base directory
BASEDIR="${HOME}/src"

# get list of git repositories from base directory
readarray -t REPOS < <(find "${BASEDIR}" -type d -name '.git')

# loop through each repo in base directory
for REPO in "${REPOS[@]}"; do
	# remove .git from repo
	REPO="${REPO%.git}"
	# print repo name
	tput rev; tput bold; echo " ${REPO} "; tput sgr0
	# show git status
	 git --git-dir="${REPO}/.git" --work-tree="${REPO}" status -s -b
done
