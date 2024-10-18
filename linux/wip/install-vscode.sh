#!/usr/bin/env bash

text() { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

vscode_apt(){
    text 'installing vscode'
    wget -4O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo apt-get install --assume-yes /tmp/code.deb
}

vscode_dnf(){
    text 'installing vscode'
    wget -4O /tmp/code.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64'
    sudo dnf install --assumeyes /tmp/code.rpm
}

vscode_yay(){
    text 'installing vscode'
    yay -S --noconfirm --needed visual-studio-code-bin
}

vscode_paru(){
    text 'installing vscode'
    paru -S --noconfirm --needed visual-studio-code-bin
}

vscode_exts(){
    text 'installing vscode extensions'
    exts=(
        DavidAnson.vscode-markdownlint
        formulahendry.code-runner
        GitHub.github-vscode-theme
        mechatroner.rainbow-csv
        ms-vscode-remote.remote-wsl
        oderwat.indent-rainbow
        PKief.material-icon-theme
        PKief.material-product-icons
        shd101wyy.markdown-preview-enhanced
        timonwong.shellcheck
        yzane.markdown-pdf
    )

    for ext in "${exts[@]}"; do
        code --install-extension "${ext}" --force; done
    text 'installed extensions'
    code --list-extensions --show-versions
}

# detect package managers
if [[ -f /usr/bin/apt ]]; then
    PKG="apt"
elif [[ -f /usr/bin/dnf ]]; then
    PKG="dnf"
elif [[ -f /usr/bin/yay ]]; then
    PKG="yay"
elif [[ -f /usr/bin/paru ]]; then
    PKG="paru"
else
    echo 'unsupported package manager'
    exit
fi

# begin script from here
case "${PKG}" in
    apt)    vscode_apt ;;
    dnf)    vscode_dnf ;;
    yay)    vscode_yay ;;
    paru)   vscode_paru ;;
    *)      echo 'unsupported package manager'; exit ;;
esac

# common
vscode_exts
