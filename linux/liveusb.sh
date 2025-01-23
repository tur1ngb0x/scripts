#!/bin/sh

live_sysctl() {
	sudo sh -c '
		sysctl -w net.ipv6.conf.all.disable_ipv6=1
		sysctl -w net.ipv6.conf.default.disable_ipv6=1
		sysctl -w net.ipv6.conf.lo.disable_ipv6=1
		sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
		sysctl -w vm.swappiness=0
		sysctl -w vm.overcommit_memory=2
	'
}

live_systemd() {
	{ set -x; }
	sudo sh -c '
		systemctl restart NetworkManager
		i=10; while [ "$i" -ge 0 ]; do printf "\r%2d" "$i"; sleep 1; i=$((i-1)); done; echo
		ping -4 -c10 google.com
	'
	{ set +x; }
}

live_host() {
    sudo sh -c '
		printf "127.0.0.1 localhost\n127.0.1.1 live\n" > /etc/hosts
    	hostnamectl hostname live
	'
}

live_time() {
	sudo sh -c '
		timedatectl set-timezone Asia/Kolkata
		timedatectl set-local-rtc 1
		timedatectl set-ntp 1
		timedatectl --adjust-system-clock
	'
}

live_updates() {
	sudo sh -c '
		apt-get clean || dnf clean all || pacman -Scc
    	apt-get update || dnf upgrade --refresh || pacman -Syu
		packages="curl wget git micro nano vim xclip"
		apt-get install -y ${packages} || dnf install -y ${packages} || pacman -S ${packages}
	'
}

live_git() {
    mkdir -p "$HOME/src/"

	if [ -d "${HOME}"/src/dotfiles ]; then
		cd "${HOME}"/src/dotfiles || return
		git pull
	else
		git clone https://github.com/tur1ngb0x/dotfiles "${HOME}"/src/dotfiles
	fi

	if [ -d "${HOME}"/src/scripts ]; then
		cd "${HOME}"/src/scripts || return
		git pull
	else
		git clone https://github.com/tur1ngb0x/scripts "${HOME}"/src/scripts
	fi
}

live_brave() {
    if ! command -v brave-browser > /dev/null 2>&1; then
        wget -4O '/tmp/brave.sh' 'https://dl.brave.com/install.sh'
        sh '/tmp/brave.sh'
		sudo sed -i 's|deb \[|deb [arch=amd64 |' /etc/apt/sources.list.d/brave-browser-release.list
    else
        echo "already installed at $(command -v brave-browser)"
    fi
}

live_chrome() {
    if ! command -v google-chrome > /dev/null 2>&1; then
        wget -4O '/tmp/chrome.deb' 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
        sudo sh -c 'apt-get install -y /tmp/chrome.deb'
    else
        echo "already installed at $(command -v google-chrome)"
    fi
}

live_edge() {
    if ! command -v microsoft-edge > /dev/null 2>&1; then
        wget -4O '/tmp/edge.deb' 'https://go.microsoft.com/fwlink?linkid=2149051'
        sudo sh -c 'apt-get install -y /tmp/edge.deb'
    else
        echo "already installed at $(command -v microsoft-edge)"
    fi
}

main() {
    #live_sysctl
    #live_host
    #live_time
	live_systemd
    #live_updates
    #live_git
    #live_brave
    #live_chrome
    #live_edge
}


main "$@"
