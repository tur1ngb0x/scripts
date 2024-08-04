#!/usr/bin/env bash

# shellcheck source=/dev/null

LC_ALL=C; export LC_ALL

#######################################################################
# helpers
#######################################################################
row(){
	printf -- '%9s : %s\n' "${1}" "${2}"
}

separator(){
	printf -- '*%.0s' {1..48}; printf '\n'
}

usage()
{
	cat << EOF
Description
    Show distribution information using bash.
Syntax
    $ ${0##*/} <option>
Options
                                         use long format (default)
    --short, -short, short --s, -s, s    use short format
    --help, -help, help, --h, -h, h      show help
EOF
}

#######################################################################
# data
#######################################################################

get_user(){
	if [[ -f /usr/bin/id ]]; then
		printf '%s' "$(id --user --name)"
	else
		printf '%s' '-'
	fi
}

get_host(){
	if [[ -f /usr/bin/hostname ]]; then
		printf '%s' "$(hostname --long)"
	else
		printf '%s' '-'
	fi
}

get_now(){
	if [[ -f /usr/bin/date ]]; then
		printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')"
	else
		printf '%s' '-'
	fi
}

get_vendor(){
	if [[ -f /sys/devices/virtual/dmi/id/sys_vendor ]]; then
		printf '%s' "$(cat /sys/devices/virtual/dmi/id/sys_vendor)"
	else
		printf '%s' '-'
	fi
}

get_machine(){
	if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
		printf '%s' "$(cat /sys/devices/virtual/dmi/id/product_name)"
	else
		printf '%s' '-'
	fi
}

get_distro(){
	if [[ -f /etc/os-release ]]; then
		printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")"
	else
		printf '%s' '-'
	fi
}

get_kernel(){
	if [[ -f /usr/bin/uname ]]; then
		printf '%s' "$(uname --kernel-release)"
	else
		printf '%s' '-'
	fi
}

get_display(){
	if [[ $(tty) == *tty* ]]; then
		printf '%s' '-'
	elif [[ -f /usr/bin/xrandr ]]; then
		xrandr &> /dev/null
		if [[ ${?} == '1' ]]; then
			printf '%s' '-'
		else
			printf '%s' "$(xrandr | awk '/connected primary/{getline;{print $1"@"$2}}' | sed "s/\..*//")"
		fi
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
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MiB"
	else
		printf '%s' '-'
	fi
}

get_ram_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MiB"
	else
		printf '%s' '-'
	fi
}

get_swap_total(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $2}')MiB"
	else
		printf '%s' '-'
	fi
}

get_swap_used(){
	if [[ -f /usr/bin/free ]]; then
		printf '%s' "$(free --mebi | awk 'FNR == 3 {print $3}')MiB"
	else
		printf '%s' '-'
	fi
}

get_uptime(){
	if [[ -f /usr/bin/uptime ]]; then
		printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')"
	else
		printf '%s' '-'
	fi
}

get_packages(){
	get_dpkg(){	(dpkg --list | grep -c '^ii'); }
	get_dnf(){ (dnf list --installed | grep -c ''); }
	get_pacman(){ (pacman -Qq | grep -c ''); }
	# get_docker(){	(docker images --format "{{.Repository}}" | grep -c ''); }
	# get_flatpak(){ (flatpak list --all | grep -c ''); }
	# get_pipx(){ (pipx list --short | grep -c ''); }
	# get_snap(){ (snap list --all | grep -c ''); }
	if [[ -f /usr/bin/dpkg ]]; then printf '%s' "$(get_dpkg)"; fi
	if [[ -f /usr/bin/dnf ]]; then printf '%s' "$(get_dnf)"; fi
	if [[ -f /usr/bin/pacman ]]; then printf '%s' "$(get_pacman)"; fi
	# if [[ -f /usr/bin/flatpak ]]; then printf '%s' "$(get_flatpak)(flatpak) "; fi
	# if [[ -f /usr/bin/snap ]]; then printf '%s' "$(get_snap)(snap) "; fi
	# if [[ -f /usr/bin/docker ]]; then printf '%s' "$(get_docker)(docker) "; fi
	# if [[ -f /usr/bin/pipx ]]; then printf '%s' "$(get_pipx)(pipx) "; fi
}

get_colors(){
	for c in {0..8}; do
		printf '\e[48;5;%dm ' "${c}"
    done
	printf "\e[0m\n"
}

fetch-short(){
	cat << EOF | tr '[:upper:]' '[:lower:]'

  distro : $(printf '%s' "$(source /etc/os-release; echo "${ID}-${VERSION_ID}")")
  kernel : $(printf '%s' "$(uname --kernel-release)")
  memory : $(printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MiB")
  uptime : $(printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')")

EOF
}

# function fetch-short {
# 	separator
# 	row 'Distro'	"$(get_distro)"
# 	row 'Kernel'	"$(get_kernel)"
# 	row 'Memory'	"$(get_ram_used)"
# 	row 'Uptime'	"$(get_uptime)"
# 	separator
# }

fetch-long(){
	separator
	row 'Hardware'	"$(get_vendor) $(get_machine)"
	row 'Distro'	"$(get_distro)"
	row 'Kernel'	"$(get_kernel)"
	row 'Display'	"$(get_display)"
	row 'Desktop'	"$(get_desktop)"
	row 'Memory'	"$(get_ram_used) / $(get_ram_total)"
	row 'Swap'		"$(get_swap_used) / $(get_swap_total)"
	row 'Uptime'	"$(get_uptime)"
	row 'Packages'	"$(get_packages)"
	separator
}

#######################################################################
# begin script from here
#######################################################################
option="${1}"
shift

case "${option}" in
	--help | -help | help | --h | -h | h)    usage ;;
	--short | -short | --s | -s)             fetch-short ;;
	*)                                       fetch-long ;;
esac
