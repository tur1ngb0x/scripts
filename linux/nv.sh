#!/usr/bin/env bash

set -e
set -o pipefail
set -u
set -x

sudo wget -4O /tmp/envycontrol.py 'https://raw.githubusercontent.com/bayasdev/envycontrol/main/envycontrol.py'
sudo prime-select on-demand
sudo systemctl mask gpu-manager.service
sudo /tmp/envycontrol.py --switch integrated

set +e
set +o pipefail
set +u
set +x
