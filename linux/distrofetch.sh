#!/usr/bin/env bash
# shellcheck source=/dev/null

LC_ALL=C
export LC_ALL

function usage {
	cat << EOF
DESCRIPTION
    Show distribution information using pure bash
SYNTAX
    $ ${0##*/} <option>
OPTIONS
    --long, -long, long, --l, -l, l       use long format (default)
    --short, -short, short, --s, -s, s    use short format
    --help, -help, help, --h, -h, h       show help
USAGE
    $ ${0##*/}
    $ ${0##*/} -s
EOF
}

#######################################################################
# helpers
#######################################################################
function row { printf -- '%9s : %s\n' "${1}" "${2}"; }
function separator { printf -- '*%.0s' {1..60}; printf '\n'; }

#######################################################################
# get data
#######################################################################
function get_user {
    if command -v id &> /dev/null; then
        printf '%s' "$(id --user --name)"
    else
        printf '%s' '-'
    fi
}

function get_host {
    if command -v hostname &> /dev/null; then
        printf '%s' "$(hostname --long)"
    else
        printf '%s' '-'
    fi
}

function get_now {
    if command -v date &> /dev/null; then
        printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')"
    else
        printf '%s' '-'
    fi
}

function get_hardware {
    if [[ -f /sys/devices/virtual/dmi/id/sys_vendor ]] && [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
        printf '%s %s' "$(cat /sys/devices/virtual/dmi/id/sys_vendor)" "$(cat /sys/devices/virtual/dmi/id/product_name)"
    else
        printf '%s' '-'
    fi
}

function get_distro {
    if [[ -f /etc/os-release ]]; then
        printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")"
    else
        printf '%s' '-'
    fi
}

function get_kernel {
    if command -v uname &> /dev/null; then
        printf '%s' "$(uname --kernel-release)"
    else
        printf '%s' '-'
    fi
}

function get_display {
    if [[ $(tty) == *tty* ]]; then
        printf '%s' '-'
    elif command -v xrandr &> /dev/null; then
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

function get_desktop {
    if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
        printf '%s@%s' "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}"
    else
        printf '%s' '-'
    fi
}

function get_ram {
    if command -v free &> /dev/null; then
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')" "$(free --mebi | awk 'FNR == 2 {print $2}')"
    else
        printf '%s' '-'
    fi
}

function get_swap {
    if command -v free &> /dev/null; then
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 3 {print $3}')" "$(free --mebi | awk 'FNR == 3 {print $2}')"
    else
        printf '%s' '-'
    fi
}

function get_uptime {
    if command -v uptime &> /dev/null; then
        printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hours/hr/g; s/ hour/hr/g; s/ minutes/min/g')"
    else
        printf '%s' '-'
    fi
}

function get_packages {
    for pm in dpkg dnf pacman flatpak snap docker pipx; do
        if command -v "${pm}" &> /dev/null; then
            case "${pm}" in
                dpkg) printf '%s(dpkg) ' "$(dpkg --list | grep -c '^ii')" ;;
                dnf) printf '%s(dnf) ' "$(dnf list --installed | grep -c '')" ;;
                pacman) printf '%s(pacman) ' "$(pacman -Qq | wc -l)" ;;
                flatpak) printf '%s(flatpak) ' "$(flatpak list --all | wc -l)" ;;
                snap) printf '%s(snap) ' "$(snap list --all | wc -l)" ;;
                docker) printf '%s(docker) ' "$(docker images --format "{{.Repository}}" | wc -l)" ;;
                pipx) printf '%s(pipx) ' "$(pipx list --short | wc -l)" ;;
            esac
        fi
    done
}

function get_shell {
    if [[ -n "${SHELL}" ]]; then
        printf '%s' "${SHELL}"
    else
        printf '%s' '-'
    fi
}

get_colors () {
    for i in {0..15}; do
        printf '\e[48;5;%dm    ' "${i}"
    done
    printf "\e[0m\n"
}

#######################################################################
# display data short format
#######################################################################
fetch_short() {
    cat <<-EOF | tr '[:upper:]' '[:lower:]'
 Distro : $(printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")")
 Kernel : $(printf '%s' "$(uname --kernel-release)")
 Memory : $(printf '%sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')")
 Uptime : $(printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')")
EOF
    #colors: $(for i in {0..15}; do printf '\e[48;5;%dm ' "${i}"; done; printf "\e[0m\n")
}

#######################################################################
# display data long format (default)
#######################################################################
fetch_long() {
    get_colors
    row 'Hardware'  "$(get_hardware)"
    row 'Distro'    "$(get_distro)"
    row 'Kernel'    "$(get_kernel)"
    row 'Display'   "$(get_display)"
    row 'Desktop'   "$(get_desktop)"
    row 'RAM'       "$(get_ram)"
    row 'Swap'      "$(get_swap)"
    row 'Uptime'    "$(get_uptime)"
    row 'Shell'     "$(get_shell)"
    row 'Packages'  "$(get_packages)"
    get_colors
}

#######################################################################
# begin script from here
#######################################################################
option="${1}"
shift

case "${option}" in
    --help | -help | help | --h | -h | h)       usage ;;
    --long | -long | long | --l | -l | l)       fetch_long ;;
    --short | -short | short | --s | -s | s)    fetch_short ;;
    *)                                          fetch_long ;;
esac
