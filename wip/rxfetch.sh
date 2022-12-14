#!/usr/bin/env bash

#colors
#bold="(tput bold)"
magenta="\033[1;35m"
green="\033[1;32m"
white="\033[1;37m"
blue="\033[1;34m"
red="\033[1;31m"
black="\033[1;40;30m"
yellow="\033[1;33m"
cyan="\033[1;36m"
reset="\033[0m"
bgyellow="\033[1;43;33m"
bgwhite="\033[1;47;37m"
c0=${reset}
c1=${magenta}
c2=${green}
c3=${white}
c4=${blue}
c5=${red}
c6=${yellow}
c7=${cyan}
c8=${black}
c9=${bgyellow}
c10=${bgwhite}

# Setup fonts


# Get the init
get_init() {
	os=$(uname -o)
	if [ "$os" = "Android" ]; then
		echo 'init.rc'
	elif pidof -q systemd; then
		echo 'systemd'
	elif [ -f '/sbin/openrc' ]; then
		echo 'openrc'
	else
		cut -d ' ' -f 1 /proc/1/comm
	fi
}

# Get count of packages installed
get_pkg_count() {
	package_managers=('xbps-install' 'apk' 'apt' 'pacman' 'nix' 'dnf' 'rpm' 'emerge')
	for package_manager in ${package_managers[@]}; do
		if command -v $package_manager 2>/dev/null>&2; then
			case "$package_manager" in
				xbps-install ) xbps-query -l | wc -l ;;
				apk ) apk search | wc -l ;;
				apt ) apt list --installed 2>/dev/null | wc -l ;;
				pacman ) pacman -Q | wc -l ;;
				nix ) nix-env -qa --installed '*' | wc -l ;;
				dnf ) dnf list installed | wc -l ;;
				rpm ) rpm -qa | wc -l ;;
				emerge ) qlist -I | wc -l ;;
			esac

			# if a package manager is found return from the function
			return
		fi
	done
	echo 'Unknown'
}

# Get distro name
get_distro_name() {
	os=$(uname -o)
	if [ "$os" = "Android" ] ; then
		echo 'Android'
	else
		awk -F '"' '/PRETTY_NAME/ { print $2 }' /etc/os-release
	fi
}

# Get root partition space used
get_storage_info() {
	df -h --output=used,size /home | awk 'NR == 2 { print $1" / "$2 }'
}

# Get Memory usage
get_mem() {
	free --mega | awk 'NR == 2 { print $3" / "$2" MB" }'
}

# Get uptime
get_uptime() {
	uptime -p | sed 's/up//'
}

# Get DE/WM
# Reference: https://github.com/unixporn/robbb/blob/master/fetcher.sh
get_de_wm() {
	wm="${XDG_CURRENT_DESKTOP#*:}"
	[ "$wm" ] || wm="$DESKTOP_SESSION"

	# for most WMs
	[ ! "$wm" ] && [ "$DISPLAY" ] && command -v xprop >/dev/null && {
		id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
		id=${id##* }
		wm=$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t | grep '^_NET_WM_NAME' | cut -d\" -f 2)
	}

	# for non-EWMH WMs
	[ ! "$wm" ] || [ "$wm" = "LG3D" ] &&
		wm=$(ps -e | grep -m 1 -o \
			-e "sway" \
			-e "kiwmi" \
			-e "wayfire" \
			-e "sowm" \
			-e "catwm" \
			-e "fvwm" \
			-e "dwm" \
			-e "2bwm" \
			-e "monsterwm" \
			-e "tinywm" \
			-e "xmonad")

	echo ${wm:-unknown}
}


echo -e "               ${c1}os${c3}     $(get_distro_name)"
echo -e "               ${c2}krnl${c3}   $(uname -r)"
echo -e "     ${c3}???${c8}_${c3}???${c0}       ${c7}pkgs${c3}   $(get_pkg_count)"
echo -e "     ${c8}${c0}${c9}oo${c0}${c8}|${c0}       ${c4}sh${c3}     ${SHELL##*/}"
echo -e "    ${c8}/${c0}${c10}???${c0}${c8}'\'${c0}      ${c6}ram${c3}    $(get_mem)"
echo -e "   ${c9}(${c0}${c8}\_;/${c0}${c9})${c0}      ${c1}init${c3}   $(get_init)"
echo -e "               ${c2}de/wm${c3}  $(get_de_wm)"
echo -e "               ${c7}up${c3}    $(get_uptime)"
echo -e "               ${c6}disk${c3}   $(get_storage_info)"
