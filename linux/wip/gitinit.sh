#!/usr/bin/env bash
usage() {
	cat <<EOF

Description:
    Initialize git repo, add and commit all files, push to remote.
	Root Directory: "${HOME}"/src/

Syntax:
    $ ${0##*/} <repository>

Usage:
    $ ${0##*/} dotfiles
    $ ${0##*/} scripts

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

repo="${1}"

# create folder
[[ ! -d "${HOME}"/src/"${repo}"/ ]] && mkdir -pv "${HOME}"/src/"${repo}"/

# if folder exists, move into it.
[[ -d "${HOME}"/src/"${repo}"/ ]] && pushd "${HOME}"/src/"${repo}"/

# if existing repo is present, remove it
[[ -d "${HOME}"/src/"${repo}"/.git/ ]] && rm -f -r -v .git

# initialize git repo
git init -b main

# if README.md does not exist, create one
[[ ! -f "${HOME}"/src/"${repo}"/README.md ]] && echo "# ${repo}" > README.md

# add all files
git add .

# commit all files
git commit --allow-empty-message -m ''

# add remote
git remote add origin https://github.com/tur1ngb0x/"${repo}".git

# force push
git push -f -u origin main

# exit from folder
popd
