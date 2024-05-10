#!/usr/bin/env bash

dt-distro(){
	source /etc/os-release; echo "${PRETTY_NAME}"
}

dt-kernel(){
	uname --kernel-release
}

dt-ram(){
	free --mebi | awk 'FNR == 2 {print $3}')MiB
}

dt-uptime(){
	uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g'
}

# begin script from here
cat << EOF | tr '[:upper:]' '[:lower:]'
***********************************************************************
    distro : $(dt-distro)
    kernel : $(dt-kernel)
    memory : $(dt-ram)
    uptime : $(dt-uptime)
***********************************************************************
EOF
