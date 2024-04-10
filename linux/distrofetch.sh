#!/usr/bin/env bash

# shellcheck source=/dev/null

# checks
# cmds=(cat free grep uname uptime)
# for c in "${cmds[@]}"; do
# 	if [[ ! $(command -v "${c}" ) ]]; then
# 		echo "${c} does not exist in ${PATH}, cannot proceed, exiting"
# 		exit
# 	fi
# done

# helpers
row(){
	printf -- '%10s : %s\n' "${1}" "${2}"
}

separator(){
	printf -- '—%.0s' {1..72}; printf '\n'
}

# data
#get_display(){ [[ -f /usr/bin/xrandr ]] && xrandr | grep '\*' | awk '{print $1"@"$2}' | sed "s/\..*//" || echo '-'; }
#get_colorbar(){ for ((n=0;n<16;n++)) do printf "$(tput setaf ${n})%s$(tput sgr0)" '#'; done; printf '\n'; }
#get_colorbar(){ for i in {0..15}; do tput setaf "${i}"; printf "%s" "#"; done; }

get_user(){
	printf '%s' "$(id --user --name)" 2> /dev/null
}

get_now(){
	printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')" 2> /dev/null
}

get_machine(){
	if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
		cat /sys/devices/virtual/dmi/id/product_name 2> /dev/null
	else
		echo '-'
	fi
}

get_distro(){
	if [[ -f /etc/os-release ]]; then
		source /etc/os-release 2> /dev/null
		echo "${PRETTY_NAME}" 2> /dev/null
	else
		echo '-'
	fi
}

get_kernel(){
	if [[ -f /usr/bin/uname ]]; then
		uname --kernel-release 2> /dev/null
	else
		echo '-'
	fi
}

get_display(){
	if [[ -f /usr/bin/xrandr ]]; then
		xrandr | grep '\*' | awk '{print $1"@"$2}' | sed "s/\..*//"
	else
		echo '-'
	fi
}

get_desktop(){
	if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
		echo "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}" 2> /dev/null
	else
		echo '-'
	fi
}

get_ram_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MB" 2> /dev/null
	else
		echo '-'
	fi
}

get_ram_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MB" 2> /dev/null
	else
		echo '-'
	fi
}

get_swap_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $2}')MB" 2> /dev/null
	else
		echo '-'
	fi
}

get_swap_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $3}')MB" 2> /dev/null
	else
		echo '-'
	fi
}

get_uptime(){
	if [[ -f /usr/bin/uptime ]]; then
		uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g' 2> /dev/null
	else
		echo '-'
	fi
}

get_packages(){
	if [[ -f /usr/bin/dpkg ]]; then printf '%s' "$(dpkg -l | grep -c '^ii')(apt) "; fi
	if [[ -f /usr/bin/dnf ]]; then printf '%s' "$(dnf list --installed | grep -c '')(dnf) "; fi
	if [[ -f /usr/bin/pacman ]]; then printf '%s' "$(pacman -Qq | grep -c '')(pacman) "; fi
	if [[ -f /usr/bin/flatpak ]]; then printf '%s' "$(flatpak list --all | grep -c '')(flatpak) "; fi
	if [[ -f /usr/bin/snap ]]; then printf '%s' "$(snap list --all | grep -c '')(snap) "; fi
	if [[ -f /usr/bin/docker ]]; then printf '%s' "$(docker images --format "{{.Repository}}" | grep -c '')(docker) "; fi
}

# begin script from here
separator
row 'USER'		"$(get_user)"
row 'NOW'		"$(get_now)"
separator
row 'MACHINE'	"$(get_machine)"
row 'DISTRO'	"$(get_distro)"
row 'KERNEL'	"$(get_kernel)"
row 'DISPLAY'	"$(get_display)"
row 'DESKTOP'	"$(get_desktop)"
row 'RAM'		"$(get_ram_used)/$(get_ram_total)"
row 'SWAP'		"$(get_swap_used)/$(get_swap_total)"
row 'UPTIME'	"$(get_uptime)"
row 'PACKAGES'	"$(get_packages)"
separator
