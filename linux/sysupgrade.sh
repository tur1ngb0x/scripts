#!/usr/bin/env bash

function text { printf "\033[7m # %s \033[0m\n" "$(command -v "${1}")"; }

function show { (set -x; "${@:?}"); }

function elevate_user {
    if [[ "$(id -ur)" -eq 0 ]]; then
        ELEVATE=""
    elif [[ -f /usr/bin/doas ]]; then
        ELEVATE="doas"
    elif [[ -f /usr/bin/sudo ]]; then
        ELEVATE="sudo"
    else
        echo 'Install sudo or doas'
        exit
    fi
}

function pause_script {
    echo "${1}"
    read -r -n 1 -p "${2}"
}

function upgrade_apt {
    if command -v apt-get &> /dev/null; then
        text 'apt'
        show ${ELEVATE} apt-get clean
        show ${ELEVATE} apt-get update
        show ${ELEVATE} apt-get dist-upgrade
        show ${ELEVATE} apt-get install --assume-yes bash bash-completion curl wget git nano vim xclip
        show ${ELEVATE} apt-get purge --autoremove
    fi
}

function upgrade_apk {
    if command -v apk &> /dev/null; then
        text 'apk'
        ${ELEVATE} apk cache clean
        ${ELEVATE} apk update
        ${ELEVATE} apk upgrade --progress
        ${ELEVATE} apk add bash bash-completion curl wget ncurses git nano vim xclip
    fi
}

function upgrade_dnf {
    if command -v dnf &> /dev/null; then
        text 'dnf'
        ${ELEVATE} dnf clean all
        ${ELEVATE} dnf upgrade --refresh --assumeyes
        ${ELEVATE} dnf install --assumeyes bash bash-completion curl wget ncurses git nano procps-ng vim xclip
        ${ELEVATE} dnf autoremove
    fi
}

function setup_pacman {
    # https://gitlab.archlinux.org/archlinux/packaging/packages/pacman/-/blob/main/pacman.conf
    # https://gitlab.archlinux.org/archlinux/packaging/packages/pacman/-/raw/main/pacman.conf
    # cat /tmp/pacman.conf | grep -v '^#' | sed 's/ \{2,\}/ /g' | awk NF
    if command -v pacman &> /dev/null; then
        text 'pacman'
        cat <<-'EOF' | ${ELEVATE} tee /etc/pacman.conf
[options]
Architecture = x86_64
HoldPkg = pacman glibc
DownloadUser = alpm
ParallelDownloads = 8
LocalFileSigLevel = Optional
SigLevel = Required DatabaseOptional
CheckSpace
Color
ILoveCandy
VerbosePkgLists

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

#[endeavouros]
#Include = /etc/pacman.d/endeavouros-mirrorlist
#SigLevel = PackageRequired
EOF
    fi
}

function upgrade_pacman {
    if command -v pacman &> /dev/null; then
        text 'pacman'
        ${ELEVATE} pacman -Scc
        ${ELEVATE} pacman -Syyu --needed --noconfirm base-devel reflector bash bash-completion curl wget git nano vim xclip
        ${ELEVATE} reflector --verbose --ipv4 --protocol http,https --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
        ${ELEVATE} pacman -Syyu
    fi
}

function upgrade_snap {
    if command -v snap &> /dev/null; then
        text 'snap'
        ${ELEVATE} snap refresh
        ${ELEVATE} snap refresh --hold
        ${ELEVATE} snap set system snapshots.automatic.retention=no
        ${ELEVATE} snap list --all | while read -r name version revision tracking publisher notes; do if [[ "${notes}" = *disabled* ]]; then
            echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
            ${ELEVATE} snap remove --purge "${name}" --revision="${revision}"
        fi; done
        unset name version revision tracking publisher notes
        #sudo snap remove --purge $(sudo snap list --all | awk 'NR > 1 {print $1}' | xargs)
    fi
}

function upgrade_flatpak {
    if command -v flatpak &> /dev/null; then
        text 'flatpak'
        flatpak --user update --appstream --assumeyes
        flatpak --user update --assumeyes
        flatpak --user uninstall --unused --delete-data --assumeyes
        flatpak --system update --appstream --assumeyes
        flatpak --system update --assumeyes
        flatpak --system uninstall --unused --delete-data --assumeyes
    fi
}

function upgrade_code {
    if command -v code &> /dev/null; then
        text 'code'
        code --update-extensions
    fi
}

function upgrade_docker {
    if command -v docker &> /dev/null; then
        text 'docker'
        export DOCKER_CLI_HINTS="false"
        for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
            docker pull "${img}"
        done
    fi
}

function upgrade_pipx {
    if command -v pipx &> /dev/null; then
        text 'pipx'
        USE_EMOJI="0" pipx upgrade-all
    fi
}

function set_shell {
    if command -v bash &> /dev/null; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            source /usr/share/bash-completion/bash_completion
        fi
    fi
}

function set_ps1 {
    PS1='\n$(tput rev) \u@\h \w $(tput sgr0)\n\$ '; PS1="\[\e]0;\u@\h \w\a\]${PS1}"
    export PS1
}

function main {
    export LC_ALL=C

    elevate_user

    upgrade_apt

    upgrade_apk

    upgrade_dnf

    setup_pacman;upgrade_pacman

    upgrade_code

    upgrade_docker
    
    upgrade_pipx

    upgrade_flatpak
    
    upgrade_snap

    pause_script 'End of the script. Press any key to exit'
}

# begin script from here
main "${@}"
