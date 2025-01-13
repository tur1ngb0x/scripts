#!/usr/bin/env bash

LC_ALL=C

function text {
    tput rev
    printf "\n# %s\n" "$(which "${1}")"
    tput sgr0
}

function elevate_user {
    if [[ $(command -v sudo) ]]; then
        ELEVATE="sudo"
    elif [[ $(command -v doas) ]]; then
        ELEVATE="doas"
    elif [[ $(command -v sudo-rs) ]]; then
        ELEVATE="sudo-rs"
    else
        ELEVATE=""
        echo "Supported tools: doas, sudo, sudo-rs"
        exit
    fi
}

function upgrade_apt {
    if [[ -f /usr/bin/apt-get ]]; then
        text 'apt'
        "${ELEVATE}" apt-get clean
        "${ELEVATE}" apt-get update
        "${ELEVATE}" apt-get dist-upgrade
        "${ELEVATE}" apt-get install bash-completion curl wget git nano vim xclip
        source /usr/share/bash-completion/bash_completion
        "${ELEVATE}" apt-get purge --autoremove
    fi
}

function upgrade_apk {
    if [[ -f /usr/bin/apk ]]; then
        "${ELEVATE}" apk cache clean
        "${ELEVATE}" apk update
        "${ELEVATE}" apk upgrade --progress
    fi
}

function upgrade_dnf {
    if [[ -f /usr/bin/dnf ]]; then
        text 'dnf'
        "${ELEVATE}" dnf clean all
        "${ELEVATE}" dnf upgrade --refresh
        "${ELEVATE}" dnf install --assumeyes bash-completion curl wget git nano vim xclip
        source /usr/share/bash-completion/bash_completion
        "${ELEVATE}" dnf autoremove
    fi
}

function upgrade_pacman {
    if [[ -f /usr/bin/pacman ]]; then
        text 'pacman'
        cat <<-EOF | "${ELEVATE}" tee /etc/pacman.conf
[options]
Architecture = x86_64
HoldPkg = pacman glibc
LocalFileSigLevel = Optional
ParallelDownloads = 8
SigLevel = Required DatabaseOptional

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
        "${ELEVATE}" pacman -Scc
        "${ELEVATE}" pacman -Syyu --needed --noconfirm base-devel reflector
        "${ELEVATE}" pacman -Syyu --needed --noconfirm bash-completion git nano vim xclip
        source /usr/share/bash-completion/bash_completion
        "${ELEVATE}" reflector --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
        "${ELEVATE}" pacman -Scc
        "${ELEVATE}" pacman -Syyu
    fi
}

function upgrade_snap {
    if [[ -f /usr/bin/snap ]]; then
        text 'snap'
        "${ELEVATE}" snap refresh
        "${ELEVATE}" snap refresh --hold
        "${ELEVATE}" snap set system snapshots.automatic.retention=no
        "${ELEVATE}" snap list --all | while read -r name version revision tracking publisher notes; do if [[ "${notes}" = *disabled* ]]; then
            echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
            "${ELEVATE}" snap remove --purge "${name}" --revision="${revision}"
        fi; done
        unset name version revision tracking publisher notes
        #sudo snap remove --purge $(sudo snap list --all | awk 'NR > 1 {print $1}' | xargs)
    fi
}

function upgrade_flatpak {
    if [[ -f /usr/bin/flatpak ]]; then
        text 'flatpak'
        flatpak --user update --appstream
        flatpak --user update
        flatpak --user uninstall --unused --delete-data
        flatpak --system update --appstream
        flatpak --system update
        flatpak --system uninstall --unused --delete-data
    fi
}

function upgrade_code {
    if [[ -f /usr/bin/code ]]; then
        text 'code'
        code --update-extensions
    fi
}

function upgrade_docker {
    if [[ -f /usr/bin/docker ]]; then
        text 'docker'
        export DOCKER_CLI_HINTS="false"
        for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
            docker pull "${img}"
        done
    fi
}

function upgrade_pipx {
    if [[ -f /usr/bin/pipx ]]; then
        text 'pipx'
        USE_EMOJI="0" pipx upgrade-all
    fi
}

function main {
    elevate_user
    upgrade_apt
    upgrade_apk
    upgrade_dnf
    upgrade_pacman
    upgrade_code
    upgrade_docker
    upgrade_pipx
    upgrade_flatpak
    upgrade_snap
}

# begin script from here
main "${@}"
