#!/usr/bin/env bash

# fail safe
set -euxo pipefail
LC_ALL="C"

# get current working directory
CWD="$(builtin cd "$(command dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && builtin pwd -P)"

# set origin
ORIGIN="https://github.com/tur1ngb0x/scripts.git"

# backup current working directory
command cp -av "${CWD}" "${CWD}.bak-$(command date +%Y%m%d-%H%M%S)"

# enter dir
builtin pushd "${CWD}" || builtin exit

# remove repo metadata
command rm -rfv .git

# create repo
command git init --initial-branch 'main'

# set origin
command git remote add origin "${ORIGIN}"

# add files
command git add --verbose --all

# commit files
command git commit --verbose --allow-empty --allow-empty-message --message ''

# push
command git push --verbose --set-upstream --force origin main

# exit dir
builtin popd || builtin exit
