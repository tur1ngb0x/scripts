#!/usr/bin/env bash

text() { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

git_apt(){
    text 'installing git'
    sudo apt-add-repository --yes ppa:git-core/ppa
    sudo apt update
    sudo apt install --assume-yes git build-essential
    sudo apt install --reinstall --assume-yes libsecret-1-0 libsecret-1-dev
    sudo rm -fv /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
    sudo make -C /usr/share/doc/git/contrib/credential/libsecret
    sudo strip --strip-unneeded /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
    sed -i 's/#apt/helper/g' "${HOME}"/.config/git/config
}

git_dnf(){
    text 'installing git'
    sudo dnf install --assumeyes git git-credential-libsecret
    sed -i 's/#dnf/helper/g' "${HOME}"/.config/git/config
}

git_pacman(){
    text 'installing git'
    sudo pacman -Syu --needed --noconfirm git
    sed -i 's/#pacman/helper/g' "${HOME}"/.config/git/config
}

key_ssh(){
    name_remote="${1}"
    name_user="${2}"
    key_private="ssh-rsa4096-${1}-${2}"
    key_public="${key_private}.pub"
    echo -e "name_remote: ${name_remote}"
    echo -e "name_user: ${name_user}"
    echo -e "key_private: ${key_private}"
    echo -e "key_public: ${key_public}"
    text "generating private ssh key for ${2}@${1}"
    ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/${key_private}" -C "${key_private}"
    text "adding ssh agent"
    eval "$(ssh-agent -s)" &> /dev/null
    text "adding private ssh key for ${2}@${1}"
    ssh-add "${HOME}/.ssh/${key_private}"
    text "generated public ssh key for ${2}@${1}"
    cat "${HOME}/.ssh/${key_public}"
}

repo_clone(){
	mkdir "${HOME}"/src
	pushd "${HOME}"/src || exit
	git clone "${@}"
	popd || exit
}

# detect package managers
if [[ -f /usr/bin/apt ]]; then
    PKG="apt"
elif [[ -f /usr/bin/dnf ]]; then
    PKG="dnf"
elif [[ -f /usr/bin/pacman ]]; then
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
#key_ssh 'github' 'tur1ngb0x'
#key_ssh 'gitlab' 'tur1ngb0x'
#repo_clone 'https://github.com/smxi/inxi'
#repo_clone 'https://github.com/dylanaraps/neofetch'
#repo_clone 'https://github.com/tur1ngb0x/scripts'
#repo_clone 'https://github.com/tur1ngb0x/dotfiles'
#repo_clone 'https://github.com/tur1ngb0x/notes'
#repo_clone 'https://github.com/tur1ngb0x/binaries'
