#!/usr/bin/env bash

text() { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

pkgs_snap=(
	pieces-os
	pieces-for-developers
)

pkgs_flatpak=(
	com.authy.Authy
	com.bitwarden.desktop
	com.discordapp.Discord
	com.google.Chrome
	com.microsoft.Edge
	com.valvesoftware.Steam
	io.mgba.mGBA
	org.kde.gwenview
	org.kde.kolourpaint
	org.kde.okular
	org.mozilla.firefox
	org.qbittorrent.qBittorrent
	org.telegram.desktop
	org.videolan.VLC
)

ppas_ubuntu=(
	'ppa:flatpak/stable'
	'ppa:git-core/ppa'
	'ppa:papirus/papirus'
)

pkgs_ubuntu=(
	atool
	bash-completion
	build-essential
	curl
	dos2unix
	ffmpeg
	git
	mediainfo
	most
	nano
	p7zip-full
	p7zip-rar
	pipx
	python-is-python3
	python3-pip
	python3-venv
	tree
	vim
	wget
	xclip
	virt-manager
)

function post_virt-manager {
	sudo groupadd -f kvm
	sudo usermod -aG kvm "${USER}"
	sudo groupadd -f libvirt
	sudo usermod -aG libvirt "${USER}"
	cat <<-'EOF' | sudo tee -a /etc/libvirt/libvirtd.conf
	unix_sock_group = "libvirt"
	unix_sock_ro_perms = "0770"
	unix_sock_rw_perms = "0770"
	auth_unix_ro = "none"
	auth_unix_rw = "none"
	EOF
	cat <<-EOF | sudo tee -a /etc/libvirt/qemu.conf
	user = "${USER}"
	group = "${USER}"
	EOF
}

function post_mysql {
	mysql --show-warnings --user root --password --execute "\
		DROP USER IF EXISTS user@localhost;\
		CREATE USER IF NOT EXISTS user@localhost IDENTIFIED BY '1234567890';\
		GRANT ALL PRIVILEGES ON *.* TO user@localhost;\
		FLUSH PRIVILEGES;\
	"
	mysql --show-warnings --user root --password --execute "\
		SELECT user,host,plugin,password_expired FROM mysql.user;\
	"
}

# text 'pkgs_snap''        for pkg in "${pkgs_snap[@]}";       do echo "${pkg}"; done
# text 'pkgs_flatpak';     for pkg in "${pkgs_flatpak[@]}";    do echo "${pkg}"; done
# text 'ppa_ubuntu';       for ppa in "${ppa_ubuntu[@]}";      do echo "${ppa}"; done
# text 'pkgs_ubuntu';      for pkg in "${pkgs_ubuntu[@]}";     do echo "${pkg}"; done

#text 'pkgs_snap';        for pkg in "${pkgs_snap[@]}";       do sudo snap install           "${pkg}";   done
#text 'pkgs_flatpak';     for pkg in "${pkgs_flatpak[@]}";    do flatpak install -y          "${pkg}";   done
#text 'ppa_ubuntu';       for ppa in "${ppa_ubuntu[@]}";      do sudo apt-add-repository -y  "${ppa}";   done
#text 'pkgs_ubuntu';      for pkg in "${pkgs_ubuntu[@]}";     do sudo apt-get install -y     "${pkg}";   done
