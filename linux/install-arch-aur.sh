
_install_yay () {
    sudo pacman --sync --needed git base-devel
    sudo rm -fr /tmp/yay-bin
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg --cleanbuild --clean --syncdeps --install --force --rmdeps
}


_install_paru () {
    sudo pacman --sync --needed git base-devel
    sudo rm -fr /tmp/paru-bin
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
    cd /tmp/paru-bin
    makepkg --cleanbuild --clean --syncdeps --install --force --rmdeps
}


_install_pikaur () {
    sudo pacman --sync --needed git base-devel
    sudo rm -fr /tmp/pikaur
    git clone https://aur.archlinux.org/pikaur.git /tmp/pikaur
    cd /tmp/pikaur
    makepkg --cleanbuild --clean --syncdeps --install --force --rmdeps
}

