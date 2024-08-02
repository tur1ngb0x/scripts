#!/usr/bin/env bash

sudo wget -4O /tmp/envycontrol.py 'https://raw.githubusercontent.com/bayasdev/envycontrol/main/envycontrol.py'
sudo prime-select on-demand
sudo systemctl mask gpu-manager.service
sudo python3 /tmp/envycontrol.py --switch integrated
