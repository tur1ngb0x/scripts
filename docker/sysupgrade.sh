
upg_apt() {
    apt-get clean
    apt-get update
    apt-get dist-upgrade
    apt-get install bash-completion git micro nano vim xclip
    source /usr/share/bash-completion/bash_completion
    apt-get purge --autoremove
}

upg_apk(){
    apk cache clean
    apk update
    apk upgrade --progress
}

upg_dnf() {
    dnf clean all
    dnf upgrade --refresh
    dnf install --assumeyes bash-completion git micro nano vim xclip
    source /usr/share/bash-completion/bash_completion
    dnf autoremove
}

upg_pacman() {
    cat << EOF | tee /etc/pacman.conf
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
    pacman -Scc
    pacman -Syyu --needed --noconfirm base-devel reflector
    pacman -Syyu --needed --noconfirm bash-completion git micro nano vim xclip
    source /usr/share/bash-completion/bash_completion
    cp -fv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    reflector --verbose --ipv4 --protocol http,https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
	pacman-key --init
	pacman-key --populate archlinux
	pacman -Scc
    pacman -Syyu --needed --noconfirm
    pacman -Fyy --noconfirm
}


if [ -f /usr/bin/apt-get ]; then upg_apt;exit; fi

if [ -f /usr/bin/apk ]; then upg_apk;exit; fi

if [ -f /usr/bin/dnf ]; then upg_dnf;exit; fi

if [ -f /usr/bin/pacman ]; then upg_pacman;exit; fi
