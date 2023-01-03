#!/usr/bin/env bash

# micro
sudo bash -c 'pushd /usr/local/bin && curl https://getmic.ro | sh && popd'

# ncdu
sudo bash -c 'wget -4O- https://dev.yorhel.nl/download/ncdu-2.2.1-linux-x86_64.tar.gz | tar xvz -C /usr/local/bin'

# starship
sudo sh -c 'wget -4O /tmp/starship.sh https://raw.githubusercontent.com/starship/starship/master/install/install.sh && sh /tmp/starship.sh -y'

# yt-dlp
sudo bash -c 'wget -4O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && chmod +x /usr/local/bin/yt-dlp'

# fix permissions
sudo chown -Rv root:root /usr/local/bin

# toolbox
wget -4O- 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA' | tar -xvz --strip-components=1 -C /tmp && /tmp/jetbrains-toolbox

# quick emu
mkdir -pv ~/src
git clone https://github.com/quickemu-project/quickemu ~/src/quickemu
sudo apt-get install --install-recommends -y qemu bash coreutils ovmf grep jq lsb procps python3 genisoimage usbutils util-linux sed spice-client-gtk swtpm wget xdg-user-dirs zsync unzip
