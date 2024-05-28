#!/usr/bin/env bash

# $HOME/src/dotfiles
find "${HOME}"/src/dotfiles/ -mindepth 1 -type f -not -path "${HOME}/src/dotfiles/windows/*" -exec dos2unix --follow-symlink --verbose {} \;
find "${HOME}"/src/dotfiles/windows/ -mindepth 1 -type f -exec unix2dos --follow-symlink --verbose {} \;

# $HOME/src/scripts
find "${HOME}"/src/scripts/ -mindepth 1 -type f -not -path "${HOME}/src/scripts/windows/*" -exec dos2unix --follow-symlink --verbose {} \;
find "${HOME}"/src/scripts/windows/ -mindepth 1 -type f -exec unix2dos --follow-symlink --verbose {} \;

# $HOME/src/notes
find "${HOME}"/src/notes/ -mindepth 1 -type f -exec dos2unix --follow-symlink --verbose {} \;
