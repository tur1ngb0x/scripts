#!/usr/bin/env bash

INXI_LOG="${HOME}/inxi-$(date +'%Y%m%d-%H%M%S')"

sudo bash -c 'inxi --admin --full --repos --processes --extra 3 --width 1 --filter-all' | tee "${INXI_LOG}"

xdg-open "${INXI_LOG}"
