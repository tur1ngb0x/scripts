#!/usr/bin/env bash

directory="${1}"

tput rev; echo -e "Changing directory ownership to ${USER}"; tput sgr0
sudo chown --recursive --verbose "${USER}":"${USER}" "${directory}"

tput rev; echo -e "Changing directory file endings to Unix style..."; tput sgr0
find -L "${directory}"  -mindepth 1 -type f -exec dos2unix --follow-symlink --allow-chown --verbose {} \;

tput rev; echo -e "\n\nChanging directory folder permissions to 0755..."; tput sgr0
find -L "${directory}"  -type d -exec chmod --verbose 0755 {} \;

tput rev; echo -e "\n\nChanging directory file permissions to 0664..."; tput sgr0
find -L "${directory}"  -type f -exec chmod --verbose 0664 {} \;

#find -L "${directory}"  -type f -exec chmod --verbose --changes 0644 {} \;
