#!/usr/bin/env bash

dt-line(){
	printf -- '-%.0s' {1..48}; printf '\n'
}

dt-distro(){
	printf '%s' "$(source /etc/os-release; echo "${ID}-${VERSION_ID}")"
}

dt-kernel(){
	printf '%s' "$(uname --kernel-release)"
}

dt-ram(){
	printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MiB"
	#printf ' %s ' '/'
	#printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MiB"
}

dt-uptime(){
	printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')"
}

# begin script from here
cat << EOF | tr '[:upper:]' '[:lower:]'
$(dt-line)
distro : $(dt-distro)
kernel : $(dt-kernel)
memory : $(dt-ram)
uptime : $(dt-uptime)
$(dt-line)
EOF
