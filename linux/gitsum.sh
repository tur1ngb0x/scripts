#!/usr/bin/env bash

# save PAGER value
oldpager="${PAGER}"
oldmanpager="${MANPAGER}"

# disable pager
unset PAGER
unset MANPAGER

# set base directory
BASEDIR="${HOME}/src"

# get list of git repositories from base directory
readarray -t REPOS < <(find "${BASEDIR}" -type d -name '.git')

# loop through each repo in base directory
for REPO in "${REPOS[@]}"; do
	# remove .git from repo
	REPO="${REPO%.git}"
	# print repo name
	tput rev; tput bold; echo -e "\n ${REPO} "; tput sgr0
	# show git branch
	#git --git-dir="${REPO}/.git" --work-tree="${REPO}" branch --all --no-color
	# show git remote
	git --git-dir="${REPO}/.git" --work-tree="${REPO}" remote --verbose | awk 'NR==1 {print $2}'
	# show git status
	git --git-dir="${REPO}/.git" --work-tree="${REPO}" status --short --branch

done

# re-enable pager
PAGER=${oldpager}
MANPAGER=${oldmanpager}
