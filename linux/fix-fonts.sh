#/usr/bin/env bash

tput rev; tput blink; tput bold; echo ' fixing font permissions '; tput sgr0
sudo chown --recursive --verbose root:root /usr/share/fonts

tput rev; tput blink; tput bold; echo ' cleaning font config root '; tput sgr0
sudo rm -frv /root/.cache/fontconfig
sudo rm -frv /root/.fontconfig
sudo rm -frv /var/cache/fontconfig

tput rev; tput blink; tput bold; echo ' cleaning font config user '; tput sgr0
sudo rm -frv "${HOME}"/.cache/fontconfig

tput rev; tput blink; tput bold; echo ' regenerating font cache root '; tput sgr0
sudo fc-cache --force --really-force --verbose

tput rev; tput blink; tput bold; echo ' regenerating font cache user '; tput sgr0
fc-cache --force --really-force --verbose
