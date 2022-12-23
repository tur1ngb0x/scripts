#!/usr/bin/env bash

sudo snap remove --purge firefox
sudo snap refresh
sudo snap install authy
sudo snap install powershell --classic
sudo snap refresh --hold
