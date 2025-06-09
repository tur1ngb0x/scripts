#!/usr/bin/env bash

[[ $(lspci | grep 'VGA' | grep 'Intel') ]] && echo 'VGA:Intel detected' || exit

[[ $(lspci | grep '3D' | grep 'NVIDIA') ]] && echo '3D:Nvidia detected' || exit

[[ $(command -v system76-power) ]] && echo 'system-76-power detected' || exit

[[ $(system76-power graphics) == 'integrated' ]] && echo 'integrated graphics mode detected' || exit

[[ $(system76-power graphics switchable) == 'switchable' ]] && echo 'switchable graphics detected' || exit

[[ $(system76-power graphics power) == 'on (discrete)' ]] && echo '3D:Nvidia is powered on' || exit

[[ $(command -v system76-power) ]] && echo 'turning off 3D:Nvidia' && system76-power graphics power off && echo 'done'
