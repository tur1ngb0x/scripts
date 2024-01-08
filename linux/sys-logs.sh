#!/usr/bin/env bash

journalctl_system="journalctl --no-pager --system --catalog --boot 0 --priority 3"
tput rev; tput blink; tput bold; echo "${journalctl_system}"; tput sgr0
eval "${journalctl_system}"

journalctl_user="journalctl --no-pager --user --catalog --boot 0 --priority 3"
tput rev; tput blink; tput bold; echo "${journalctl_user}"; tput sgr0
eval "${journalctl_user}"
