#!/usr/bin/env bash

sudo bash -c '
    systemctl stop --force --now NetworkManager sshd ssh
    systemctl restart --force --now NetworkManager sshd ssh
'
