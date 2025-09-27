#!/usr/bin/env bash

check_pkgs() {
    local pkgs=( "$@" )
    for i in "${pkgs[@]}"; do
        if ! command -v "${i}" &> /dev/null; then
            echo "Error: ${i} is not installed." >&2
            exit 1
        fi
    done
}

check_pkgs git column fzf awk xargs

git --no-pager log --date='format:%Y%m%d-%H:%M:%S' --pretty='format:%ad|%h|%s' | column -t -N 'Date,Commit,Message' -o '    ' -s '|' | fzf --header-lines=1 | awk '{print $2}' | xargs git show
