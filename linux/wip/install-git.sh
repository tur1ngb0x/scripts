#!/usr/bin/env bash

function show () { (set -x; "${@:?}"); }

function text () { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

function git_apt () {
    #show sudo apt-add-repository ppa:git-core/ppa
    show sudo apt update
    show sudo apt install --assume-yes git build-essential
    show sudo apt install --reinstall --assume-yes libsecret-1-0 libsecret-1-dev
    show sudo rm -fv /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
    show sudo make -C /usr/share/doc/git/contrib/credential/libsecret
    show sudo strip --strip-unneeded /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
    show sed -i 's/#apt/helper/g' "${HOME}"/.config/git/config
}

function git_dnf () {
    show sudo dnf install --assumeyes git git-credential-libsecret
    show sed -i 's/#dnf/helper/g' "${HOME}"/.config/git/config
}

function git_pacman () {
    show sudo pacman -Syu --needed --noconfirm git
    show sed -i 's/#pacman/helper/g' "${HOME}"/.config/git/config
}

function key_ssh () {
    name_remote="${1}"
    name_user="${2}"
    key_private="ssh-rsa4096-${1}-${2}"
    key_public="${key_private}.pub"

    echo -e "name_remote: ${name_remote}"
    echo -e "name_user: ${name_user}"
    echo -e "key_private: ${key_private}"
    echo -e "key_public: ${key_public}"
    
    show ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/${key_private}" -C "${key_private}"
    show eval "$(ssh-agent -s)" &> /dev/null
    show ssh-add "${HOME}/.ssh/${key_private}"
    show cat "${HOME}/.ssh/${key_public}"
}

function repo_clone () {
	show mkdir "${HOME}"/src
	show pushd "${HOME}"/src || exit
	show git clone "${@}"
	show popd || exit
}

# detect package managers
if command -v apt &> /dev/null; then
    PKG="apt"
elif command -v dnf &> /dev/null; then
    PKG="dnf"
elif command -v pacman &> /dev/null; then
    PKG="pacman"
else
    echo 'only apt, dnf, pacman are supported'
fi

# begin script from here
case "${PKG}" in
    apt)    git_apt		;;
    dnf)    git_dnf		;;
    pacman) git_pacman	;;
    *)      echo 'only apt, dnf, pacman are supported' ;;
esac

# common
# key_ssh $REMOTE $USER
key_ssh 'github' 'tur1ngb0x'
key_ssh 'gitlab' 'tur1ngb0x'

#repo_clone 'https://github.com/smxi/inxi'
#repo_clone 'https://github.com/dylanaraps/neofetch'
#repo_clone 'https://github.com/tur1ngb0x/scripts'
#repo_clone 'https://github.com/tur1ngb0x/dotfiles'
#repo_clone 'https://github.com/tur1ngb0x/notes'
#repo_clone 'https://github.com/tur1ngb0x/binaries'
