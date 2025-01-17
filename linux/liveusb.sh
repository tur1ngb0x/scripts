#!/bin/sh

live_network() {
    sudo sh -c 'sysctl -w net.ipv6.conf.all.disable_ipv6=1'
    sudo sh -c 'sysctl -w net.ipv6.conf.default.disable_ipv6=1'
    sudo sh -c 'sysctl -w net.ipv6.conf.lo.disable_ipv6=1'
    sudo sh -c 'systemctl restart NetworkManager'
}

live_host() {
    sudo sh -c 'printf "127.0.0.1 localhost\n127.0.1.1 live\n" > /etc/hosts'
    sudo sh -c 'hostnamectl hostname live'
}

live_time() {
    timedatectl set-timezone Asia/Kolkata
    timedatectl set-local-rtc 1
    timedatectl set-ntp 1
    timedatectl --adjust-system-clock
}

live_updates() {
    sudo sh -c 'apt-get clean || dnf clean all || pacman -Scc'
    sudo sh -c 'apt-get update || dnf upgrade --refresh || pacman -Syu'
    sudo sh -c 'apt-get install -y curl wget git micro nano vim xclip || dnf install -y curl wget git micro nano vim xclip || pacman -S curl wget git micro nano vim xclip'
}

live_git() {
    mkdir -p "$HOME/src/"
    git clone https://github.com/tur1ngb0x/dotfiles "$HOME/src/dotfiles"
    git clone https://github.com/tur1ngb0x/scripts "$HOME/src/scripts"
}

live_brave() {
    if ! command -v brave-browser 2>&1; then
        wget -4O '/tmp/brave.sh' 'https://dl.brave.com/install.sh'
        sh '/tmp/brave.sh'
    else
        echo "already installed at $(command -v brave-browser)"
    fi
}

live_chrome() {
    if ! command -v google-chrome 2>&1; then
        wget -4O '/tmp/chrome.deb' 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
        sudo sh -c 'apt-get install -y /tmp/chrome.deb'
    else
        echo "already installed at $(command -v google-chrome)"
    fi
}

live_edge() {
    if ! command -v microsoft-edge 2>&1; then
        wget -4O '/tmp/edge.deb' 'https://go.microsoft.com/fwlink?linkid=2149051'
        sudo sh -c 'apt-get install -y /tmp/edge.deb'
    else
        echo "already installed at $(command -v microsoft-edge)"
    fi
}

main() {
    live_network
    live_host
    live_time
    live_updates
    live_git
    live_brave
    live_chrome
    live_edge
}

main "$@"
