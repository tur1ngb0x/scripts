#!/usr/bin/env bash

sudo mkdir -pv /var/lib/gdm3/.config

sudo cp -fv "${HOME}"/.config/monitors.xml /var/lib/gdm3/.config/monitors.xml

sudo chown -v gdm:gdm /var/lib/gdm3/.config/monitors.xml

# for debian systems
# sudo chown -v Debian-gdm:Debian-gdm /var/lib/gdm3/.config/monitors.xml

