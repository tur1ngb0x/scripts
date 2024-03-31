#!/usr/bin/env bash

# shellcheck source=/dev/null

# checks
cmds=(cat free grep uname uptime)
for c in "${cmds[@]}"; do
	if [[ ! $(command -v "${c}" ) ]]; then
		echo "${c} does not exist in ${PATH}, cannot proceed, exiting"
		exit
	fi
done

# helpers
row(){
	printf -- '%10s : %s\n' "${1}" "${2}"
}

separator(){
	printf -- '-%.0s' {1..72}; printf '\n'
}

# data
#get_display(){ [[ -f /usr/bin/xrandr ]] && xrandr | grep '\*' | awk '{print $1"@"$2}' | sed "s/\..*//" || echo 'N/A'; }
#get_swap_total() { printf '%s' "$(free --mebi | awk 'FNR == 3 {print $2}')MB"; }
#get_swap_used() { printf '%s' "$(free --mebi | awk 'FNR == 3 {print $3}')MB"; }
#get_colorbar(){ for ((n=0;n<16;n++)) do printf "$(tput setaf ${n})%s$(tput sgr0)" '#'; done; printf '\n'; }
#get_colorbar(){ for i in {0..15}; do tput setaf "${i}"; printf "%s" "#"; done; }

get_machine(){
	if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
		cat /sys/devices/virtual/dmi/id/product_name
	else
		echo 'NA'
	fi
}

get_distro(){
	if [[ -f /etc/os-release ]]; then
		source /etc/os-release
		echo "${PRETTY_NAME}"
	else
		echo 'NA'
	fi
}

get_kernel(){
	if [[ -f /usr/bin/uname ]]; then
		uname --kernel-release 2> /dev/null
	else
		echo 'NA'
	fi
}

get_desktop(){
	if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
		echo "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}"
	else
		echo 'NA'
	fi
}

get_ram_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MB"
	else
		echo 'NA'
	fi
}

get_ram_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MB"
	else
		echo 'NA'
	fi
}

get_uptime(){
	uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g'
}

get_packages(){
	[[ -f /usr/bin/dpkg ]] && printf '%s' "$(dpkg -l | grep -c '^ii')(apt) "
	[[ -f /usr/bin/dnf ]] && printf '%s' "$(dnf list --installed | grep -c '')(dnf) "
	[[ -f /usr/bin/pacman ]] && printf '%s' "$(pacman -Qq | grep -c '')(pacman) "
	[[ -f /usr/bin/flatpak ]] && printf '%s' "$(flatpak list --all | grep -c '')(flatpak) "
	[[ -f /usr/bin/snap ]] && printf '%s' "$(snap list --all | grep -c '')(snap) "
	[[ -f /usr/bin/docker ]] && printf '%s' "$(docker images --format "{{.Repository}}" | grep -c '')(docker) "
}

# begin script from here
separator
row 'MACHINE'	"$(get_machine)"
row 'DISTRO'	"$(get_distro)"
row 'KERNEL'	"$(get_kernel)"
row 'DESKTOP'	"$(get_desktop)"
row 'RAM'		"$(get_ram_used)/$(get_ram_total)"
row 'UPTIME'	"$(get_uptime)"
row 'PACKAGES'	"$(get_packages)"
separator
