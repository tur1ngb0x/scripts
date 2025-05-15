#!/usr/bin/env bash

function header() { printf "\033[7m # %s - %s \033[0m\n" "$(date +%H:%M:%S)" "${1}"; }

function text () { printf "%s\n" "${1}"; }

function show () { (set -x; "${@:?}"); }

function usage () {
    Treset=$(tput sgr0)
    Tbold=$(tput bold)
    Titalic=$(tput sitm)
    Tunderline=$(tput ul)
    Treverse=$(tput rev)
    Tdim=$(tput dim)
    cat << EOF
${Treverse}${Tbold} DESCRIPTION ${Treset}
Upgrade packages on the system

${Treverse}${Tbold} SYNTAX ${Treset}
$ ${0##*/} <option>

${Treverse}${Tbold} OPTIONS ${Treset}
all     Upgrade everything
apk     Upgrade APK packages
apt     Upgrade APT packages
code    Update VS Code extensions
dnf     Upgrade DNF packages
docker  Upgrade docker images
flatpak Upgrade flatpak packages
pacman  Upgrade pacman packages
pip     Upgrade pip and pipx
pipx    Upgrade pipx packages
snap    Upgrade snap packages
user    Create non-root user
help    Show help

${Treverse}${Tbold} USAGE ${Treset}
$ ${0##*/} all
$ ${0##*/} apt code docker pipx
$ ${0##*/} help
EOF
}

function prompt_user () {
    local answer
    printf "%s\n" "${1}"
    read -p "Input: " -n 1 -r answer
    text ''
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        return
    fi
}

function elevate_user () {
    if [[ "$(id --user --real)" -eq 0 ]]; then
        ELEVATE=""
    else
        if command -v sudo &> /dev/null; then
            ELEVATE="sudo"
        elif command -v sudo-rs &> /dev/null; then
            ELEVATE="sudo-rs"
        elif command -v doas &> /dev/null; then
            ELEVATE="doas"
        else
            text 'no tool found for user elevation'
            text 'install any one - sudo, sudo-rs, doas'
            exit
        fi
    fi
}

function create_user () {
    header 'create user'
    # check virtualization
    if command -v systemd-detect-virt &> /dev/null; then
        virt="$(systemd-detect-virt)"
    elif command -v virt-what &> /dev/null; then
        virt="$(virt-what)"
    else
        virt=""
    fi

    # if no virtualization, exit, else create user.
    if [[ "${virt}" = "none" ]]; then
        text 'user setup not needed'
    else
        read -r -p 'Enter name: ' DKRUSER
        if grep -q "^${DKRUSER}" /etc/passwd; then
            text "${DKRUSER} already exists on the system."
        else
            show ${ELEVATE} groupadd --force --gid 27 sudo
            show ${ELEVATE} groupadd --force --gid wheel
            show ${ELEVATE} groupadd --force --gid adm

            show ${ELEVATE} useradd --create-home --shell /bin/bash  "${DKRUSER}"
            show ${ELEVATE} passwd "${DKRUSER}"

            show ${ELEVATE} usermod --append --groups sudo "${DKRUSER}"
            show ${ELEVATE} usermod --append --groups wheel "${DKRUSER}"
            show ${ELEVATE} usermod --append --groups adm "${DKRUSER}"

            # sudo custom template
            ${ELEVATE} mkdir -p /etc/sudoers.d/
            cat << EOF | ${ELEVATE} tee /etc/sudoers.d/custom &> /dev/null
%wheel ALL=(ALL:ALL) ALL
%sudo ALL=(ALL:ALL) ALL
${DKRUSER} ALL=(ALL:ALL) ALL
EOF
            # user shell profile
            cat << EOF | ${ELEVATE} tee /home/"${DKRUSER}"/.profile &> /dev/null
source /home/${DKRUSER}/.bashrc
EOF
            # user shell bash config
            cat << 'EOF' | ${ELEVATE} tee -a /home/"${DKRUSER}"/.bashrc &> /dev/null
source /usr/share/bash-completion/bash_completion
PS1="\u@\h \w\n\$ "
EOF
        fi
        # user shell permissions
        ${ELEVATE} chown "${DKRUSER}":"${DKRUSER}" /home/"${DKRUSER}"/.profile &> /dev/null
        ${ELEVATE} chown "${DKRUSER}":"${DKRUSER}" /home/"${DKRUSER}"/.bashrc &> /dev/null  

        # all users
        header 'current users'
        show ${ELEVATE} cat /etc/passwd | awk -F: '$3 == 0 || $3 >= 1000' | sort
        header 'user details'
        awk -F: '$3 == 0 || $3 >= 1000 {print $1}' /etc/passwd | while IFS= read -r i; do
           show ${ELEVATE} id "${i}" 
        done
        header "sudo --user ${DKRUSER} --login"
    fi
}

function pause_script {
    head="${1}"
    msg="${2}"
    prompt="${3}"
    header "${head}"
    echo "${msg}"
    read -r -n 1 -p "${prompt}"
}

function upgrade_apt {
    header 'apt'
    if command -v apt &> /dev/null; then
        DEBIAN_FRONTEND="noninteractive"; export DEBIAN_FRONTEND
        show ${ELEVATE} apt clean
        show ${ELEVATE} apt update
        show ${ELEVATE} apt full-upgrade
        show ${ELEVATE} apt install --assume-yes bash bash-completion curl dialog git nano sudo vim wget
        show ${ELEVATE} apt purge --autoremove
    else
        text 'apt not found in PATH'
    fi
}

function upgrade_apk {
    header 'apk'
    if command -v apk &> /dev/null; then
        show ${ELEVATE} apk cache clean
        show ${ELEVATE} apk update
        show ${ELEVATE} apk upgrade --progress
        show ${ELEVATE} apk add bash bash-completion curl wget ncurses git nano sudo shadow vim virt-what
    else
        text 'apk not found in PATH'
    fi
}

function upgrade_dnf {
    header 'dnf'
    if command -v dnf &> /dev/null; then
        show ${ELEVATE} dnf clean all
        show ${ELEVATE} dnf upgrade --refresh --assumeyes
        show ${ELEVATE} dnf install --assumeyes bash bash-completion curl wget ncurses git nano procps-ng vim xclip
        show ${ELEVATE} dnf autoremove
    else
        text 'dnf not found in PATH'
    fi
}

function upgrade_pacman {
    header 'pacman'
#     # https://gitlab.archlinux.org/archlinux/packaging/packages/pacman/-/blob/main/pacman.conf
#     # https://gitlab.archlinux.org/archlinux/packaging/packages/pacman/-/raw/main/pacman.conf
#     # cat /tmp/pacman.conf | grep -v '^#' | sed 's/ \{2,\}/ /g' | awk NF
#     # for VM/containers : DisableSandbox
#     # for bare metal : DownloadUser = alpm 
    if command -v pacman &> /dev/null; then
        text 'pacman found in PATH'
        header 'pacman.conf'
        cat <<-'EOF' | ${ELEVATE} tee /etc/pacman.conf
[options]
Architecture = x86_64
HoldPkg = pacman glibc
ParallelDownloads = 8
LocalFileSigLevel = Optional
SigLevel = Required DatabaseOptional
#DownloadUser = alpm
DisableSandbox
#CheckSpace
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

#[chaotic-aur]
#Include = /etc/pacman.d/chaotic-mirrorlist
EOF
        header 'pacman cache'
        show ${ELEVATE} find /var/cache/pacman/pkg/ -mindepth 1 -exec rm -f {} \;
        show ${ELEVATE} find /var/lib/pacman/sync/ -mindepth 1 -exec rm -f {} \;

        header 'pacman update'
        show ${ELEVATE} pacman -Syyu --needed --noconfirm reflector
        header 'pacman mirrors'
        if [ "$(find /etc/pacman.d/mirrorlist -type f -mmin +60 2> /dev/null)" ]; then
            text '/etc/pacman.d/mirrorlist was modified more than 60 minutes ago.'
            show ${ELEVATE} reflector --verbose --ipv4 --protocol http,https --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
        else
            text '/etc/pacman.d/mirrorlist was modified less than 60 minutes ago.'
        fi

        header 'pacman packages'
        show ${ELEVATE} pacman -Syu --needed --noconfirm base-devel bash bash-completion curl dialog git micro nano pacman-contrib reflector sudo vim wget
    
        header 'yay'
        if command -v yay &> /dev/null; then
            text 'yay is already installed.'
        else
            show rm -fr /tmp/yay-bin
            show git clone --depth=1 https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
            
            # disable debug flag
            show cp -f /etc/makepkg.conf /etc/makepkg.conf.bak
            sed -i "/^OPTIONS=(/s/ *debug//" /etc/makepkg.conf
            
            # bypass root warning
            show cp -f /usr/sbin/makepkg /usr/sbin/makepkg.bak
            show sed -i "/exit \$E_ROOT/ s/^/#/g" /usr/sbin/makepkg

            show makepkg --dir /tmp/yay-bin --clean --cleanbuild --force --syncdeps --install --needed --noconfirm
        fi

        header 'pacman *.pacnew *.pacsave'
        show sudo find /etc -name '*.pacnew' 2> /dev/null
        show sudo find /etc -name '*.pacsave' 2> /dev/null
    else
        text 'pacman not found in PATH'
    fi
}

function upgrade_snap {
    if command -v snap &> /dev/null; then
        header 'snap'
        show ${ELEVATE} snap refresh
        show ${ELEVATE} snap refresh --hold
        show ${ELEVATE} snap set system snapshots.automatic.retention=no
        ${ELEVATE} snap list --all --unicode=never --color=never | while read -r name version revision tracking publisher notes; do
            if [[ "${notes}" = *disabled* ]]; then
                echo "${name}" "${version}" "${tracking}" "${publisher}" "${notes}"
                show ${ELEVATE} snap remove --purge "${name}" --revision="${revision}"
            fi; done
        unset name version revision tracking publisher notes
        #sudo snap remove --purge $(sudo snap list --all | awk 'NR > 1 {print $1}' | xargs)
    fi
}

function upgrade_flatpak {
    if command -v flatpak &> /dev/null; then
        header 'flatpak'
        show flatpak --user update --appstream --assumeyes
        show flatpak --user update --assumeyes
        show flatpak --user uninstall --unused --delete-data --assumeyes
        show flatpak --system update --appstream --assumeyes
        show flatpak --system update --assumeyes
        show flatpak --system uninstall --unused --delete-data --assumeyes
    fi
}

function upgrade_code {
    if command -v code &> /dev/null; then
        header 'code'
        #show code --update-extensions
        for ext in $(code --list-extensions); do
            show code --install-extension "${ext}" --force
        done
    fi
}

function upgrade_docker {
    if command -v docker &> /dev/null; then
        header 'docker'
        DOCKER_CLI_HINTS="false"; export DOCKER_CLI_HINTS
        for img in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
            show docker pull "${img}"
        done
    fi
}

function upgrade_pip {
    if command -v pip &> /dev/null; then
        header 'pip'
        show pip install --user --upgrade pip
        show pip install --user --upgrade pipx
    fi
}

function upgrade_pipx {
    if command -v pipx &> /dev/null; then
        header 'pipx'
        for pkg in $(pipx list --short | awk '{print $1}'); do
            show pipx upgrade "${pkg}"
            #show pipx upgrade-all
        done
    fi
}

function set_shell {
    if command -v systemd-detect-virt &> /dev/null; then
        virt="$(systemd-detect-virt)"
    elif command -v virt-what &> /dev/null; then
        virt="$(virt-what)"
    else
        virt=""
    fi

    header 'bash'
    if [[ "${virt}" = "none" ]]; then
        text 'shell setup not needed'
    else
        text 'bash; source /usr/share/bash-completion/bash_completion; PS1="\u@\h \w\n\$ "'
    fi
}

function upgrade_all {
    upgrade_apk
    upgrade_apt
    upgrade_dnf
    upgrade_pacman

    upgrade_snap
    upgrade_flatpak

    upgrade_code
    upgrade_docker

    upgrade_pip
    upgrade_pipx
}

function handle_arguments {
    if [[ "${#}" -eq 0 ]]; then
        usage
        exit 1
    fi

    local -a unique_args=()
    local arg
    local found

    for arg in "${@}"; do
        found="false"
        for existing_arg in "${unique_args[@]}"; do
            if [[ "${arg}" == "${existing_arg}" ]]; then
                found="true"
                break
            fi
        done
        if [[ "${found}" == false ]]; then
            unique_args+=("${arg}")
        fi
    done

    local upgrade_all_executed="false"

    for arg in "${unique_args[@]}"; do
        case "${arg}" in
            all)        if [[ "${upgrade_all_executed}" == false ]]; then upgrade_all; upgrade_all_executed="true"; fi ;;
            apk)        upgrade_apk     ;;
            apt)        upgrade_apt     ;;
            code)       upgrade_code    ;;
            dnf)        upgrade_dnf     ;;
            docker)     upgrade_docker  ;;
            flatpak)    upgrade_flatpak ;;
            pacman)     upgrade_pacman  ;;
            pip)        upgrade_pip     ;;
            pipx)       upgrade_pipx    ;;
            snap)       upgrade_snap    ;;
            user)       create_user     ;;
            help)       usage; exit     ;;
            *)          usage; exit 1 ;;
        esac
    done
}

function main {
    elevate_user
    handle_arguments "${@}"
}

# begin script from here
main "${@}"
