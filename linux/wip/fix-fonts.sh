#!/usr/bin/env bash

tput rev; echo ' fixing font permissions : system '; tput sgr0
sudo chown -Rv root:root /usr/share/fonts

tput rev; echo ' fixing font permissions : user '; tput sgr0
sudo chown -Rv "${USER}":"${USER}" "${HOME}"/.local/share/fonts

tput rev; echo ' cleaning font config : system '; tput sgr0
sudo rm -frv /var/cache/fontconfig

tput rev; echo ' cleaning font config : root '; tput sgr0
sudo rm -frv /root/.cache/fontconfig
sudo rm -frv /root/.fontconfig

tput rev; echo ' cleaning font config : user '; tput sgr0
sudo rm -frv "${HOME}"/.cache/fontconfig

tput rev; echo ' regenerating font cache : root '; tput sgr0
sudo fc-cache -frv

tput rev; echo ' regenerating font cache : user '; tput sgr0
fc-cache -frv
