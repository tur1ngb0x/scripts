#!/usr/bin/env bash

# micro
sudo bash -c 'pushd /usr/local/bin && curl https://getmic.ro | sh && popd'

# ncdu
sudo bash -c 'wget -O- https://dev.yorhel.nl/download/ncdu-2.2.1-linux-x86_64.tar.gz | tar xvz -C /usr/local/bin'

# starship
sudo sh -c 'wget -O /tmp/starship.sh https://raw.githubusercontent.com/starship/starship/master/install/install.sh && sh /tmp/starship.sh -y'

# yt-dlp
sudo bash -c 'wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && chmod +x /usr/local/bin/yt-dlp'

# fix permissions
sudo chown -R root:root /usr/local/bin
