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
    else
        printf '%s\n' 'Status: Fail'
        printf '%s\n' "Found: ${cmdyes[*]}"
       printf '%s\n' "Missing: ${cmdno[*]}"
        cat << EOF
Debian/Ubuntu: apt install coreutils procps x11-utils
RHEL/Fedora:   dnf install coreutils procps-ng hostname xrandr
Arch:          pacman -Syu coreutils inetutils procps-ng uutils-coreutils xorg-xrandr
Alpine:        apk add     busybox procps xrandr
EOF
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
#        printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")"
#        printf '%s' "$(source /etc/os-release; printf '%s' "${PRETTY_NAME}")"
        source /etc/os-release; printf '%s' "${PRETTY_NAME}"
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
        if [[ ${?} == '1' ]]; then
            print_na
        else
            #printf '%s' "$(xrandr | awk '/connected primary/{getline;{print $1"@"$2}}' | sed "s/\..*//")"
            df_display_id="$(xrandr | awk '/[^ ]* connected primary/ {print $1}')"
            df_display_xy="$(xrandr | grep '.*+$' | awk '{print $1}')"
            df_display_hz="$(xrandr | grep '.*+$' | awk '{print $2}' | sed 's/*+//')"
            printf '%s@%s@%s' "${df_display_id}" "${df_display_xy}" "${df_display_hz}"

           # printf '%s' "$(xrandr | awk '/connected primary/{getline; print $1 "@" $2 "@" $4}' | sed "s/\..*//")"
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
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')" "$(free --mebi | awk 'FNR == 2 {print $2}')"
    else
        print_na
    fi
}

function get_swap {
    if command -v free &> /dev/null; then
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 3 {print $3}')" "$(free --mebi | awk 'FNR == 3 {print $2}')"
    else
        print_na
    fi
}

function get_uptime {
    if command -v uptime &> /dev/null; then
        printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hours/hr/g; s/ hour/hr/g; s/ minutes/min/g')"
    else
        print_na
    fi
}

# function get_packages {
#     for pm in dpkg dnf pacman flatpak snap docker pipx; do
#         if command -v "${pm}" &> /dev/null; then
#             case "${pm}" in
#                 dpkg) printf '%s(dpkg) ' "$(dpkg --list | grep -c '^ii')" ;;
#                 dnf) printf '%s(dnf) ' "$(dnf list --installed | grep -c '')" ;;
#                 pacman) printf '%s(pacman) ' "$(pacman -Qq | wc -l)" ;;
#                 flatpak) printf '%s(flatpak) ' "$(flatpak list --all | wc -l)" ;;
#                 snap) printf '%s(snap) ' "$(snap list --all | wc -l)" ;;
#                 docker) printf '%s(docker) ' "$(docker images --format "{{.Repository}}" | wc -l)" ;;
#                 pipx) printf '%s(pipx) ' "$(pipx list --short | wc -l)" ;;
#             esac
#         fi
#     done
# }


# function get_packages {
#     for pm in dpkg dnf pacman; do
#         if command -v "${pm}" &> /dev/null; then
#             case "${pm}" in
#                 dpkg)   printf '%s(dpkg) '   "$(dpkg --list | grep -c '^ii')" ;;
#                 dnf)    printf '%s(dnf) '    "$(dnf list --installed | grep -c '')" ;;
#                 pacman) printf '%s(pacman) ' "$(pacman -Qq | wc -l)" ;;
#             esac
#         fi
#     done
# 	pm_user=()
# 	for pm in docker pipx flatpak snap; do
# 		if command -v "${pm}" &> /dev/null; then
# 			dc="$(docker images --format '{{.Repository}}' &> /dev/null | wc -l)(docker)"
# 			fc="$(flatpak list --all &> /dev/null | wc -l)(flatpak)"
# 			pc="$(pipx list --short &> /dev/null | wc -l)(pipx)"
# 			sc="$(snap list &> /dev/null | wc -l)(snap)"
# 			pm_user=("${dc}" "${fc}" "${pc}""${sc}")
# 			printf '%s' "${pm_user[@]}"
# 		fi
# 	done
# }

# function get_packages {
# 	pm_total=()
# 	pm_1p=()
# 	pm_3p=()
#     for pm in dpkg dnf pacman; do
#         if command -v "${pm}" &> /dev/null; then
#             case "${pm}" in
#                 dpkg)   count="$(printf '%s(dpkg) '   "$(dpkg --list | grep -c '^ii')")" ;;
#                 dnf)    count="$(printf '%s(dnf) '    "$(dnf list --installed | grep -c '')")" ;;
#                 pacman) count="$(printf '%s(pacman) ' "$(pacman -Qq | wc -l)")" ;;
#             esac
# 			pm_1p+=("${count}(${pm})")
#         fi
#     done

# 	pm_3p=()
# 	for pm in snap docker pipx flatpak snap; do
# 		if command -v "${pm}" &> /dev/null; then
# 			count=""
# 			case "${pm}" in
# 				docker)  count="$(docker images --format '{{.Repository}}' &> /dev/null | wc -l)" ;;
# 				flatpak) count="$(flatpak list --all &> /dev/null | wc -l)" ;;
# 				pipx)    count="$(pipx list --short &> /dev/null | wc -l)" ;;
# 				snap)    count="$(snap list &> /dev/null | wc -l)";;
# 			esac
# 			pm_3p+=("${count}(${pm})")
# 		fi
# 	done
# 	pm_total+=("${pm_1p[@]}")
# 	pm_total+=("${pm_3p[@]}")
# 	printf '%s' "${pm_total[@]}"
# }


function get_packages {
    pm_all=()
    pm_1p=()
    pm_3p=()
    for pm in dpkg dnf pacman; do
        if command -v "${pm}" &> /dev/null; then
            count=""
            case "${pm}" in
                dpkg)   count="$(dpkg --list | grep -c '^ii')(dpkg)" ;;
                dnf)    count="$(dnf list --installed | wc -l)(dnf)" ;;
                pacman) count="$(pacman -Qq | wc -l)(pacman)" ;;
            esac
            pm_1p+=("${count}" )
        fi
    done

    pm_3p=()
    for pm in docker pipx flatpak snap; do
        if command -v "${pm}" &> /dev/null; then
            count=""
            case "${pm}" in
                docker)  count="$(docker images --format '{{.Repository}}' | wc -l)(docker)" ;;
                flatpak) count="$(flatpak list --all | wc -l)(flatpak)" ;;
                pipx)    count="$(pipx list --short | wc -l)(pipx)" ;;
                snap)    count="$(snap list &> /dev/null | wc -l)(snap)" ;;
            esac
            pm_3p+=("${count}")
        fi
    done
    pm_all+=("${pm_1p[@]}")
    pm_all+=("${pm_3p[@]}")
    printf '%s ' "${pm_all[@]}"
}

function get_shell {
    if [[ -n "${SHELL}" ]]; then
		case "${SHELL}" in
			/bin/bash)  printf '%s\n' "bash" ;;
			/bin/zsh)   printf '%s\n' "zsh" ;;
			/bin/fish)  printf '%s\n' "fish" ;;
			*)          printf '%s\n' "${SHELL}" ;;
		esac
    else
        print_na
    fi
}

function get_colors {
    for i in {0..15}; do
        printf '\e[48;5;%dm    ' "${i}"
    done
    printf "\e[0m\n"
}

#######################################################################
# display data short format
#######################################################################
function fetch_short {
    cat <<-EOF | tr '[:upper:]' '[:lower:]'
 Distro : $(source /etc/os-release; printf '%s' "${PRETTY_NAME}")
 Kernel : $(printf '%s' "$(uname --kernel-release)")
 Memory : $(printf '%sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')")
 Uptime : $(printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')")
EOF
    #colors: $(for i in {0..15}; do printf '\e[48;5;%dm ' "${i}"; done; printf "\e[0m\n")
}

#######################################################################
# display data long format (default)
#######################################################################
function fetch_long {
    get_colors
    print_row 'Hardware'  "$(get_hardware)"
    print_row 'Distro'    "$(get_distro)"
    print_row 'Kernel'    "$(get_kernel)"
    print_row 'Display'   "$(get_display)"
    print_row 'Desktop'   "$(get_desktop)"
    print_row 'RAM'       "$(get_ram)"
    print_row 'Swap'      "$(get_swap)"
    print_row 'Uptime'    "$(get_uptime)"
    print_row 'Shell'     "$(get_shell)"
    print_row 'Packages'  "$(get_packages)"
    get_colors
}

#######################################################################
# begin script from here
#######################################################################
option="${1}"
shift

case "${option}" in
    -c)    check_cmd ;;
    -h)    usage ;;
    -l)    fetch_long ;;
    -s)    fetch_short ;;
    *)     fetch_long ;;
esac
