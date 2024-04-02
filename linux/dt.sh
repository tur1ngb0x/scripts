#!/usr/bin/env bash

dt-distro(){ sed -n 's/^PRETTY_NAME="\(.*\)"$/\1/p' /etc/os-release 2>/dev/null || echo '-';}
dt-kernel(){ uname --kernel-release 2>/dev/null || echo NA;}
dt-ram(){ printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MB" 2>/dev/null || echo '-'; printf ' %s ' '/'; printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MB" 2>/dev/null || echo '-';}
dt-uptime() { uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g' 2>/dev/null || echo '-'; }

cat << EOF
Distro : $(dt-distro)
Kernel : $(dt-kernel)
RAM : $(dt-ram)
Uptime : $(dt-uptime)
EOF
