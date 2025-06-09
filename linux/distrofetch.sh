#!/usr/bin/env bash
# shellcheck source=/dev/null

LC_ALL=C
export LC_ALL

function usage {
	cat << EOF
DESCRIPTION
    Show distribution information
SYNTAX
    $ ${0##*/} <option>
OPTIONS
    -c    check requirements
    -h    show help
    -l    use long format (default)
    -s    use short format

USAGE
    $ ${0##*/}
    $ ${0##*/} -s
EOF
}

#######################################################################
# helpers
#######################################################################
function print_row { printf -- '%9s : %s\n' "${1}" "${2}"; }
function print_sep { printf -- '*%.0s' {1..60}; printf '\n'; }
function print_na { printf '%s' '?'; }
function check_cmd {
    cmdlist=(date hostname free id uname uptime xrandr)
    cmdyes=()
    cmdno=()

    for cmd in "${cmdlist[@]}"; do
        if command -v "${cmd}" &> /dev/null; then
            cmdyes+=("${cmd}") # Append to cmdyes array
        else
            cmdno+=("${cmd}")   # Append to cmdno array
        fi
    done

    printf '%s\n' "Requirements: ${cmdlist[*]}"

    # Check if cmdno array contains missing requirements
    if [ "${#cmdno[@]}" -eq 0 ]; then
        printf '%s\n' 'Status: Pass'
		return 0
    else
        printf '%s\n' 'Status: Fail'
        printf '%s\n' "Found: ${cmdyes[*]}"
       printf '%s\n' "Missing: ${cmdno[*]}"
        cat << EOF
Debian/Ubuntu: apt install bash bash-completion coreutils procps x11-utils
RHEL/Fedora:   dnf install bash bash-completion coreutils procps-ng hostname xrandr
Arch:          pacman -Syu bash bash-completion coreutils inetutils procps-ng uutils-coreutils xorg-xrandr
Alpine:        apk add     bash bash-completion coreutils busybox procps xrandr
EOF
	return 1
    fi
}

#######################################################################
# get data
#######################################################################
function get_user {
    if command -v id &> /dev/null; then
        printf '%s' "$(id --user --name)"
    else
        print_na
    fi
}

function get_host {
    if command -v hostname &> /dev/null; then
        printf '%s' "$(hostname --long)"
    else
        print_na
    fi
}

function get_now {
    if command -v date &> /dev/null; then
        printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')"
    else
        print_na
    fi
}

function get_hardware {
    if [[ -f /sys/devices/virtual/dmi/id/sys_vendor ]] && [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
        printf '%s %s' "$(cat /sys/devices/virtual/dmi/id/sys_vendor)" "$(cat /sys/devices/virtual/dmi/id/product_name)"
    else
        print_na
    fi
}

function get_distro {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release; printf '%s %s' "${NAME}" "${VERSION}"
    else
        print_na
    fi
}

function get_kernel {
    if command -v uname &> /dev/null; then
        printf '%s' "$(uname --kernel-release)"
    else
        print_na
    fi
}

function get_display {
    if [[ $(tty) == *tty* ]]; then
        print_na
    elif command -v xrandr &> /dev/null; then
        xrandr &> /dev/null
        if [[ ${?} -ne 0 ]]; then
            print_na
        else
			gd_data=""
            gd_id="$(xrandr | grep -w 'connected primary' | awk '{print $1}')"; [ -n "${gd_id}" ] && gd_data="${gd_data}${gd_id}@"
            gd_xy="$(xrandr | grep -E '\*\+' | awk '{print $1}')"; [ -n "${gd_xy}" ] && gd_data="${gd_data}${gd_xy}@"
            gd_hz="$(xrandr | grep -E '\*\+' | awk '{print int($2)}')"; [ -n "${gd_hz}" ] && gd_data="${gd_data}${gd_hz}Hz"
            # printf '%s@%s@%s' "${gd_id}" "${gd_xy}" "${gd_hz}"
			if [ -n "$gd_data" ]; then
				printf '%s\n' "$gd_data"
			else
				print_na
			fi
        fi
    else
        print_na
    fi
}

function get_desktop {
    if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
        printf '%s@%s' "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}"
    else
        print_na
    fi
}

function get_ram {
    if command -v free &> /dev/null; then
        printf '%sMiB / %sMiB' "$(free -m | awk 'FNR == 2 {print $3}')" "$(free -m | awk 'FNR == 2 {print $2}')"
    else
        print_na
    fi
}

function get_swap {
    if command -v free &> /dev/null; then
        printf '%sMiB / %sMiB' "$(free -m | awk 'FNR == 3 {print $3}')" "$(free -m | awk 'FNR == 3 {print $2}')"
    else
        print_na
    fi
}

# function get_uptime {
#     if command -v uptime &> /dev/null; then
#         printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hours/hr/g; s/ hour/hr/g; s/ minutes/min/g')"
#     else
#         print_na
#     fi
# }

# get_uptime() {
#     if [ -r /proc/uptime ]; then
#         sec=$(cut -d. -f1 /proc/uptime)
#     else
#         sec=$(($(date +%s) - $(date -d"$(uptime -s)" +%s)))
#     fi
#     d=$((sec/86400)) h=$(((sec/3600)%24)) m=$(((sec/60)%60))
#     out=
#     [ "$d" -gt 0 ] && out="${out}${d}d "
#     [ "$h" -gt 0 ] && out="${out}${h}h "
#     [ "$m" -gt 0 ] && out="${out}${m}m"
#     [ -z "$out" ] && out="${sec}s"
#     printf '%s' "${out%% }"
# }

get_uptime() {
    if command -v uptime >/dev/null 2>&1; then
        sec=$(($(date +%s) - $(date -d"$(uptime -s)" +%s)))
    elif [ -r /proc/uptime ]; then
        sec=$(cut -d. -f1 /proc/uptime)
    else
        print_na
        return
    fi

    d=$((sec/86400)) h=$(((sec/3600)%24)) m=$(((sec/60)%60))
    out=""
    [ "$d" -gt 0 ] && out="${out}${d}d "
    [ "$h" -gt 0 ] && out="${out}${h}hr "
    [ "$m" -gt 0 ] && out="${out}${m}min"
    [ -z "$out" ] && out="${sec}s"
    printf '%s' "${out%% }"
}

# function get_packages {
#     for pm in dpkg dnf pacman flatpak snap docker pipx; do
#         if command -v "${pm}" &> /dev/null; then
#             case "${pm}" in
#                 dpkg) printf 'dpkg@%s ' "$(dpkg --list | grep -c '^ii')" ;;
#                 dnf) printf 'dnf%s ' "$(dnf list --installed | grep -c '')" ;;
#                 pacman) printf 'pacman@%s ' "$(pacman -Qq | wc -l)" ;;
#                 flatpak) printf 'flatpak@%s ' "$(flatpak list --all | wc -l)" ;;
#                 snap) printf 'snap@%s ' "$(snap list --all | wc -l)" ;;
#                 docker) printf 'docker@%s ' "$(docker images --format "{{.Repository}}" | wc -l)" ;;
#                 pipx) printf 'pipx@%s ' "$(pipx list --short | wc -l)" ;;
#             esac
#         fi
#     done
# }

# function get_packages {
#     pm_all=()
#     pm_1p=()
#     pm_3p=()
#     for pm in dpkg dnf pacman; do
#         if command -v "${pm}" &> /dev/null; then
#             count=""
#             case "${pm}" in
#                 dpkg)   count="$(dpkg --list 2>/dev/null | grep -c '^ii')@dpkg" ;;
#                 dnf)    count="$(dnf list --installed 2>/dev/null | wc -l)@dnf" ;;
#                 pacman) count="$(pacman -Qq 2>/dev/null | wc -l)@pacman" ;;
#             esac
#             pm_1p+=("${count}" )
#         fi
#     done

#     pm_3p=()
#     for pm in docker pipx flatpak snap; do
#         if command -v "${pm}" &> /dev/null; then
#             count=""
#             case "${pm}" in
#                 docker)  count="$(docker images --format '{{.Repository}}' 2>/dev/null | wc -l)"; count="${count}@docker";;
#                 flatpak) count="$(flatpak list --all 2>/dev/null | wc -l)"; count="${count}@flatpak";;
#                 pipx)    count="$(pipx list --short 2>/dev/null | wc -l)"; count="${count}@pipx";;
#                 snap)    count="$(snap list --all 2>/dev/null | wc -l)"; count="${count}@snap";;
#             esac
#             pm_3p+=("${count}")
#         fi
#     done
#     pm_all+=("${pm_1p[@]}")
#     pm_all+=("${pm_3p[@]}")
#     printf '%s ' "${pm_all[@]}"
# }

function get_packages {
	# initialise empty arrays
    declare -a pm_all=()
    declare -a pm_1p=()
    declare -a pm_3p=()
    declare -A pm_cmds
    declare -A pm_pids
    declare -A pm_results

    # count packages for each package manager
    pm_cmds=(
        [dpkg]="dpkg --list 2>/dev/null | grep -c '^ii'"
        [dnf]="dnf list --installed 2>/dev/null | wc -l"
        [pacman]="pacman -Qq 2>/dev/null | wc -l"
        [docker]="docker images --format '{{.Repository}}' 2>/dev/null | wc -l"
        [pipx]="pipx list --short 2>/dev/null | wc -l"
        [flatpak]="flatpak list --all 2>/dev/null | wc -l"
        [snap]="snap list --all 2>/dev/null | wc -l"
    )

    # start async jobs for available package managers
    for pm in dpkg dnf pacman docker pipx flatpak snap; do
        if command -v "$pm" &> /dev/null; then
            eval "${pm_cmds[$pm]}" > "/dev/shm/pkg_${pm}" &
            pm_pids[$pm]=$!
        fi
    done

    # gather results
    for pm in "${!pm_pids[@]}"; do
        if wait "${pm_pids[$pm]}" 2>/dev/null; then
            pm_results[$pm]=$(<"/dev/shm/pkg_${pm}")
        else
            pm_results[$pm]="?"
        fi
        rm -f "/dev/shm/pkg_${pm}"
    done

    # format results
    for pm in dpkg dnf pacman; do
        [[ -n "${pm_results[$pm]}" ]] && pm_1p+=("${pm_results[$pm]}@${pm}")
    done

    for pm in docker pipx flatpak snap; do
        [[ -n "${pm_results[$pm]}" ]] && pm_3p+=("${pm_results[$pm]}@${pm}")
    done

	# combine results
    pm_all+=("${pm_1p[@]}")
    pm_all+=("${pm_3p[@]}")

    printf '%s ' "${pm_all[@]}"
}




function get_shell {
    if [[ -n "${SHELL}" ]]; then
		case "${SHELL}" in
			/bin/bash)  printf '%s %s' "bash" "$(bash --version | awk 'FNR==1 {print $4}' | cut -d '-' -f1)" ;;
			/bin/zsh)   printf '%s %s' "zsh"  "$(zsh --version | awk 'FNR==1 {print $2}')"  ;;
			/bin/fish)  printf '%s %s' "fish" "$(fish --version | awk 'FNR==1 {print $3}')" ;;
			/bin/dash)  printf '%s %s' "dash" " " ;;
			*)          printf '%s\n' "${SHELL}" ;;
		esac
		# printf '%s' "${SHELL}"
    else
        print_na
    fi
}

function get_colors {
    for i in {0..15}; do
        #printf '\e[48;5;%dm    ' "${i}"
		printf '\e[48;5;%dm ' "${i}"
    done
    printf "\e[0m\n"
}

#######################################################################
# display data long format (default)
#######################################################################
function fetch_long {
    print_row 'Hardware'  "$(get_hardware)"
    print_row 'Distro'    "$(get_distro)"
    print_row 'Kernel'    "$(get_kernel)"
    print_row 'Display'   "$(get_display)"
    print_row 'Desktop'   "$(get_desktop)"
    print_row 'RAM'       "$(get_ram)"
    print_row 'Swap'      "$(get_swap)"
    print_row 'Uptime'    "$(get_uptime)"
    print_row 'Packages'  "$(get_packages)"
    print_row 'Shell'     "$(get_shell)"
	print_row 'Colors'    "$(get_colors)"
}

#######################################################################
# display data short format
#######################################################################
function s_get_distro() { sed -n 's/^PRETTY_NAME=//p' /etc/os-release | tr -d '"'; }
function s_get_kernel () { printf '%s\n' "$(uname -r)"; }
function s_get_memory() { read -r _ _ used _ < <(free -m | grep 'Mem:'); printf '%sMiB' "${used}"; }
function s_get_uptime () { printf '%s\n' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')"; }

function fetch_short {
    # cat <<-EOF | tr '[:upper:]' '[:lower:]'
    cat <<-EOF
Distro : $(s_get_distro)
Kernel : $(s_get_kernel)
Memory : $(s_get_memory)
Uptime : $(s_get_uptime)
EOF
    #colors: $(for i in {0..15}; do printf '\e[48;5;%dm ' "${i}"; done; printf "\e[0m\n")
}

function main () {
	option="${1}"
	shift

	case "${option}" in
		-c)    check_cmd ;;
		-h)    usage ;;
		-l)    fetch_long ;;
		-s)    fetch_short ;;
		*)     fetch_long ;;
	esac
}

#######################################################################
# begin script from here
#######################################################################
main "${@}"
