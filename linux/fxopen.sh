#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo 'no arguments provided.'
    exit
elif [[ ! -d "${1}" ]]; then
    echo 'argument should be a path.'
    exit
fi

fxlist=(caja dolphin lf nautilus nemo pcmanfm ranger thunar xdg-open)

fxcmd=""

for fx in "${fxlist[@]}"; do
    if command -v "${fx}" &> /dev/null; then
        fxcmd="${fx}"
        break
    fi
done

if [ -z "${fxcmd}" ]; then
    echo "Supported file managers: ${fxlist[*]}"
    exit
    fi

# launch file manager
# (nohup "${fxcmd}" "${@}" &) &>/dev/null

nohup "${fxcmd}" "${@}" &>/dev/null &
