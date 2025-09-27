#!/usr/bin/env bash

INXI_LOG="${HOME}/inxi-$(date +'%Y%m%d-%H%M%S')"

# sudo bash -c 'inxi -a -F -r -t -xxx -y1 -z'
sudo bash -c 'inxi \
	--admin \
	--full \
	--repos \
	--processes cm10 \
	--width 1 \
	--filter-all' | tee "${INXI_LOG}"

code "${INXI_LOG}"
