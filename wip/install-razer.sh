#!/usr/bin/env bash

sudo apt-add-repository -yn ppa:openrazer/stable
sudo add-apt-repository -yn ppa:polychromatic/stable
sudo apt-get update
sudo apt-get install openrazer-meta polychromatic
