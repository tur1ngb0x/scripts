#!/usr/bin/env bash
# shellcheck source=/dev/null

LC_ALL=C
export LC_ALL

#######################################################################
# helpers
#######################################################################
row () { printf -- '%8s : %s\n' "${1}" "${2}"; }
separator () { printf -- '*%.0s' {1..60}; printf '\n'; }

usage () {
    Treset=$(tput sgr0)
    Tbold=$(tput bold)
    Titalic=$(tput sitm)
    Tunderline=$(tput ul)
    Treverse=$(tput rev)
    Tdim=$(tput dim)
    cat << EOF
${Treverse}${Tbold} DESCRIPTION ${Treset}
Show distribution information using pure bash

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <option>

${Treverse}${Tbold} OPTIONS ${Treset}
--long, -long, long, --l, -l, l       use long format (default)
--short, -short, short, --s, -s, s    use short format
--help, -help, help, --h, -h, h       show help

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/}
$ ${0##*/} -l
$ ${0##*/} -s
$ ${0##*/} -h
EOF
}

#######################################################################
# get data
#######################################################################
get_user () {
    if [[ $(command -v id) ]]; then
        printf '%s' "$(id --user --name)"
    else
        printf '%s' '-'
    fi
}

get_host () {
    if [[ $(command -v hostname) ]]; then
        printf '%s' "$(hostname --long)"
    else
        printf '%s' '-'
    fi
}

get_now () {
    if [[ $(command -v date) ]]; then
        printf '%s' "$(date +'%Y %B %-d %A %H:%M:%S %Z ')"
    else
        printf '%s' '-'
    fi
}

get_hardware () {
    if [[ -f /sys/devices/virtual/dmi/id/sys_vendor ]] && [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
        printf '%s %s' "$(cat /sys/devices/virtual/dmi/id/sys_vendor)" "$(cat /sys/devices/virtual/dmi/id/product_name)"
    else
        printf '%s' '-'
    fi
}

get_distro () {
    if [[ -f /etc/os-release ]]; then
        printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")"
    else
        printf '%s' '-'
    fi
}

get_kernel () {
    if [[ $(command -v uname) ]]; then
        printf '%s' "$(uname --kernel-release)"
    else
        printf '%s' '-'
    fi
}

get_display () {
    if [[ $(tty) == *tty* ]]; then
        printf '%s' '-'
    elif [[ $(command -v xrandr) ]]; then
        xrandr &>/dev/null
        if [[ ${?} == '1' ]]; then
            printf '%s' '-'
        else
            printf '%s' "$(xrandr | awk '/connected primary/{getline;{print $1"@"$2}}' | sed "s/\..*//")"
        fi
    else
        printf '%s' '-'
    fi
}

get_desktop () {
    if [[ -n "${XDG_CURRENT_DESKTOP}" ]] && [[ -n "${XDG_SESSION_TYPE}" ]]; then
        printf '%s@%s' "${XDG_CURRENT_DESKTOP}" "${XDG_SESSION_TYPE}"
    else
        printf '%s' '-'
    fi
}

get_ram () {
    if [[ $(command -v free) ]]; then
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')" "$(free --mebi | awk 'FNR == 2 {print $2}')"
    else
        printf '%s' '-'
    fi
}

get_swap () {
    if [[ $(command -v free) ]]; then
        printf '%sMiB / %sMiB' "$(free --mebi | awk 'FNR == 3 {print $3}')" "$(free --mebi | awk 'FNR == 3 {print $2}')"
    else
        printf '%s' '-'
    fi
}

get_uptime () {
    if [[ $(command -v uptime) ]]; then
        printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hours/hr/g; s/ hour/hr/g; s/ minutes/min/g')"
    else
        printf '%s' '-'
    fi
}

# get_packages () {
#     get_dpkg () { (dpkg --list | grep -c '^ii'); }
#     get_dnf () { (dnf list --installed | grep -c ''); }
#     get_pacman () { (pacman -Qq | grep -c ''); }
#     get_docker () {	(docker images --format "{{.Repository}}" | grep -c ''); }
#     get_flatpak () { (flatpak list --all | grep -c ''); }
#     get_pipx () { (pipx list --short | grep -c ''); }
#     get_snap () { (snap list --all | grep -c ''); }
#     if [[ $(command -v dpkg) ]]; then printf '%s(dpkg) ' "$(get_dpkg)"; fi
#     if [[ $(command -v dnf) ]]; then printf '%s(dnf) ' "$(get_dnf)"; fi
#     if [[ $(command -v pacman) ]]; then printf '%s(pacman) ' "$(get_pacman)"; fi
#     if [[ $(command -v flatpak) ]]; then printf '%s(flatpak) ' "$(get_flatpak)"; fi
#     if [[ $(command -v snap) ]]; then printf '%s(snap) ' "$(get_snap)"; fi
#     if [[ $(command -v docker) ]]; then printf '%s(docker) ' "$(get_docker)"; fi
#     if [[ $(command -v pipx) ]]; then printf '%s(pipx) ' "$(get_pipx)"; fi
# }

get_packages () {
    for pm in dpkg dnf pacman flatpak snap docker pipx; do
        if [[ $(command -v ${pm}) ]]; then
            case ${pm} in
                dpkg) printf '%s(dpkg) ' "$(dpkg --list | grep -c '^ii')";;
                dnf) printf '%s(dnf) ' "$(dnf list --installed | grep -c '')";;
                pacman) printf '%s(pacman) ' "$(pacman -Qq | wc -l)";;
                flatpak) printf '%s(flatpak) ' "$(flatpak list --all | wc -l)";;
                snap) printf '%s(snap) ' "$(snap list --all | wc -l)";;
                docker) printf '%s(docker) ' "$(docker images --format "{{.Repository}}" | wc -l)";;
                pipx) printf '%s(pipx) ' "$(pipx list --short | wc -l)";;
            esac
        fi
    done
}

get_shell () {
    if [[ -n "${SHELL}" ]]; then
        case "${SHELL}" in
            */bash) printf 'bash %s\n' "${BASH_VERSION}" ;;
            */zsh) printf 'zsh %s\n' "${ZSH_VERSION}" ;;
            */fish) printf 'fish %s\n' "${FISH_VERSION}" ;;
            *) printf '%s\n' "${SHELL}" ;;
        esac
    else
        printf '%s' '-'
    fi
}

get_colors () {
    for i in {0..15}; do
        printf '\e[48;5;%dm  ' "${i}"
    done
    printf "\e[0m\n"
}

#######################################################################
# display data
#######################################################################
fetch_short() {
    cat << EOF | tr '[:upper:]' '[:lower:]'
distro : $(printf '%s' "$(source /etc/os-release; echo "${PRETTY_NAME}")")
kernel : $(printf '%s' "$(uname --kernel-release)")
memory : $(printf '%sMiB' "$(free --mebi | awk 'FNR == 2 {print $3}')")
uptime : $(printf '%s' "$(uptime -p | sed 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')")
colors: $(for i in {0..15}; do printf '\e[48;5;%dm ' "${i}"; done; printf "\e[0m\n")
EOF
}

fetch_long() {
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
    row 'Colors'    "$(get_colors)"
}

#######################################################################
# begin script from here
#######################################################################
option="${1}"
shift

case "${option}" in
    --help | -help | help | --h | -h | h)   usage ;;
    --short | -short | --s | -s)            fetch_short ;;
    *)                                      fetch_long ;;
esac
