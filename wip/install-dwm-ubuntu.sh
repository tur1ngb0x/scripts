#!/usr/bin/env bash

# refresh sources
sudo apt-get update

# install requirements
sudo apt-get install build-essential libx11-dev libxft-dev libxinerama-dev stterm suckless-tools wget

# create build folder
mkdir -pv ~/src/dwm

# download archive
wget -O /tmp/dwm.tar.gz http://dl.suckless.org/dwm/dwm-6.4.tar.gz

# extract archive
tar -vxz --strip-components 1 -f /tmp/dwm.tar.gz -C ~/src/dwm

# fix permissions
sudo chown -Rv $USER:$USER ~/src/dwm

# compile source
sudo make clean install -C ~/src/dwm

# desktop entry
printf "[Desktop Entry]\nName=DWM\nExec=dwm\nType=XSession\n" | sudo tee /usr/share/xsessions/dwm.desktop
