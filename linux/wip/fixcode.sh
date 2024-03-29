#!/usr/bin/env bash

tput rev; tput bold; echo ' cleaning $HOME/.config/Code '; tput sgr0
find -L $HOME/.config/Code -mindepth 1 -maxdepth 1 -not -name 'User' -exec rm -frv {} \;

tput rev; tput bold; echo ' cleaning $HOME/.config/Code/User '; tput sgr0
find -L $HOME/.config/Code/User -mindepth 1 -maxdepth 1 -not -name 'settings.json' -exec rm -frv {} \;

tput rev; tput bold; echo ' cleaning $HOME/.vscode '; tput sgr0
find -L $HOME/.vscode -mindepth 1 -maxdepth 1 -not -name 'argv.json' -exec rm -frv {} \;

tput rev; tput bold; echo ' cleaned folders '; tput sgr0
find -L $HOME/.config/Code
find -L $HOME/.vscode
