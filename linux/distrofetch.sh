#!/usr/bin/env bash

# shellcheck source=/dev/null

# checks
cmds=(cat free grep uname uptime)
for c in "${cmds[@]}"; do if [[ ! $(command -v "${c}" ) ]]; then echo "${c} does not exist in ${PATH}, cannot proceed, exiting" && exit; fi; done

# helpers
row(){ printf -- '%10s : %s\n' "${1}" "${2}";}
separator(){ printf -- '-%.0s' {1..72}; printf '\n'; }

# data
#get_display(){ [[ -f /usr/bin/xrandr ]] && xrandr | grep '\*' | awk '{print $1"@"$2}' | sed "s/\..*//" || echo 'N/A'; }
#get_swap_total() { printf '%s' "$(free --mebi | awk 'FNR == 3 {print $2}')MB"; }
#get_swap_used() { printf '%s' "$(free --mebi | awk 'FNR == 3 {print $3}')MB"; }
#get_colorbar(){ for ((n=0;n<16;n++)) do printf "$(tput setaf ${n})%s$(tput sgr0)" '#'; done; printf '\n'; }
#get_colorbar(){ for i in {0..15}; do tput setaf "${i}"; printf "%s" "#"; done; }
get_machine(){ [[ -f /sys/devices/virtual/dmi/id/product_name ]] && cat /sys/devices/virtual/dmi/id/product_name || echo 'N/A'; }
get_distro(){ [[ -f /etc/os-release ]] && (source /etc/os-release && echo "${PRETTY_NAME}") || echo 'N/A'; }
get_kernel(){ uname --kernel-release 2> /dev/null || echo 'N/A'; }
get_desktop(){ [[ -n "${XDG_CURRENT_DESKTOP}" ]] && echo "${XDG_CURRENT_DESKTOP}" || echo 'N/A'; }
get_session(){ [[ -n "${XDG_SESSION_TYPE}" ]] && echo "${XDG_SESSION_TYPE}" || echo 'N/A'; }
get_ram_total() { printf '%s' "$(free --mebi | awk 'FNR == 2 {print $2}')MB"; }
get_ram_used() { printf '%s' "$(free --mebi | awk 'FNR == 2 {print $3}')MB"; }
get_uptime(){ uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/){d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {printf "%dd %dh %dm\n", d, h, m}'; }

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
row 'DESKTOP'	"$(get_desktop) $(get_session)"
row 'RAM'		"$(get_ram_used)/$(get_ram_total)"
row 'UPTIME'	"$(get_uptime)"
row 'PACKAGES'	"$(get_packages)"
separator
