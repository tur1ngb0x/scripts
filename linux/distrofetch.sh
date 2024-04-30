#!/usr/bin/env bash

# shellcheck source=/dev/null

#######################################################################
# helpers
#######################################################################
row(){
	printf -- '%9s : %s\n' "${1}" "${2}"
}

separator(){
	printf -- '—%.0s' {1..48}; printf '\n'
}

#######################################################################
# data
#######################################################################

get_user(){
	if [[ -f /usr/bin/id ]]; then
		printf '%s' "$(id --user --name)" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_host(){
	if [[ -f /usr/bin/hostname ]]; then
		printf '%s' "$(hostname --long)" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_now(){
	if [[ -f /usr/bin/date ]]; then
		printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_machine(){
	if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
		printf '%s' "$(cat /sys/devices/virtual/dmi/id/product_name)" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_distro(){
	if [[ -f /etc/os-release ]]; then
		printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_kernel(){
	if [[ -f /usr/bin/uname ]]; then
		printf '%s' "$(uname --kernel-release)" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_display(){
	if [[ -f /usr/bin/xrandr ]]; then
		printf '%s' "$(xrandr | awk '/connected primary/{ getline; {print $1"@"$2} } ' | sed "s/\..*//")Hz" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_desktop(){
	if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
		printf '%s@%s' "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}"
	else
		printf '%s' '-'
	fi
}

get_ram_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MiB" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_ram_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MiB" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_swap_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $2}')MiB" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_swap_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $3}')MiB" 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_uptime(){
	if [[ -f /usr/bin/uptime ]]; then
		uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g' 2> /dev/null
	else
		printf '%s' '-'
	fi
}

get_packages(){
	get_dnf(){		(dnf list --installed | grep -c '')						2> /dev/null; }
	get_docker(){	(docker images --format "{{.Repository}}" | grep -c '')	2> /dev/null; }
	get_dpkg(){		(dpkg --list | grep -c '^ii')							2> /dev/null; }
	get_flatpak(){	(flatpak list --all | grep -c '')						2> /dev/null; }
	get_pacman(){	(pacman -Qq | grep -c '')								2> /dev/null; }
	get_pipx(){		(pipx list --short | grep -c '')						2> /dev/null; }
	get_snap(){		(snap list --all | grep -c '')							2> /dev/null; }
	if [[ -f /usr/bin/dpkg ]];		then printf '%s' "$(get_dpkg)"; fi
	if [[ -f /usr/bin/dnf ]];		then printf '%s' "$(get_dnf)"; fi
	if [[ -f /usr/bin/pacman ]];	then printf '%s' "$(get_pacman)"; fi
	# if [[ -f /usr/bin/flatpak ]];	then printf '%s' "$(get_flatpak)(flatpak) "; fi
	# if [[ -f /usr/bin/snap ]];		then printf '%s' "$(get_snap)(snap) "; fi
	# if [[ -f /usr/bin/docker ]];	then printf '%s' "$(get_docker)(docker) "; fi
	# if [[ -f /usr/bin/pipx ]];		then printf '%s' "$(get_pipx)(pipx) "; fi
}

get_colors(){
	for c in {0..8}; do
		printf '\e[48;5;%dm ' "${c}"
    done
	printf "\e[0m\n"
}

#######################################################################
# begin script from here
#######################################################################
# separator
# row 'LOGIN'		"$(get_user)@$(get_host)"
# row 'NOW'		"$(get_now)"
separator
row 'Machine'	"$(get_machine)"
row 'Distro'	"$(get_distro)"
row 'Kernel'	"$(get_kernel)"
row 'Display'	"$(get_display)"
row 'Desktop'	"$(get_desktop)"
row 'Memory'	"$(get_ram_used)/$(get_ram_total)"
row 'Swap'		"$(get_swap_used)/$(get_swap_total)"
row 'Uptime'	"$(get_uptime)"
row 'Packages'	"$(get_packages)"
separator
# row 'COLORS'	"$(get_colors)"
# separator
