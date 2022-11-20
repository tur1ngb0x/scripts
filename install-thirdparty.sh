#!/usr/bin/env bash

# firefox
wget -O /tmp/ff-latest.tar.bz2 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US'
sudo tar -f /tmp/ff-latest.tar.bz2 -xvjC /opt
sudo ln -fsv /opt/firefox/firefox /usr/local/bin/firefox
sudo wget -O /usr/share/applications/firefox.desktop 'https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop'

# vscode
rm -frv "${HOME}"/VSCode-linux-x64
wget -O /tmp/vscode.tar.gz 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'
mkdir -pv "${HOME}"/vscode
tar -f /tmp/vscode.tar.gz -xvz --strip-components=1 -C "${HOME}"/vscode
cat << EOF | tee "${HOME}"/.local/share/applications/code.desktop
[Desktop Entry]
Type=Application
Name=Visual Studio Code
Exec=/home/${USER}/vscode/bin/code --disable-gpu %F
Icon=/home/${USER}/vscode/resources/app/resources/linux/code.png
Comment=Code Editing. Redefined.
Categories=Development;
Keywords=code;vscode;
MimeType=text/plain;inode/directory;
EOF
mkdir -pv "${HOME}"/.local/bin
ln -fsv "${HOME}"/vscode/bin/code "${HOME}"/.local/bin/code
mkdir -pv "${HOME}"/.local/share/bash-completion/completions
ln -fsv "${HOME}"/vscode/resources/completions/bash/code "${HOME}"/.local/share/bash-completion/completions/code

# gogh
sudo apt-get install -y dconf-cli uuid-runtime && bash -c "$(wget -qO- https://git.io/vQgMr)"

# input mono
wget -O /tmp/input-mono.zip 'https://input.djr.com/build/?fontSelection=whole&accept=I+do' && rm -frv /tmp/input-mono && unzip -jo /tmp/input-mono.zip -d /tmp/input-mono && rm -frv "${HOME}"/.local/share/fonts/input-mono && mkdir -pv "${HOME}"/.local/share/fonts/input-mono && find /tmp/input-mono -iname "InputMono-*" -exec mv -vt "${HOME}"/.local/share/fonts/input-mono {} \; && fc-cache -rv

# caskaydia cove (CaskaydiaCove Nerd Font)
mkdir -pv "${HOME}/.local/share/fonts" && wget -O "${HOME}/.local/share/fonts/caskaydia-cove-nerd-font.ttf" 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Regular.otf?raw=true' && fc-cache -rv

# jetbrains mono (JetBrainsMonoNL Nerd Font)
mkdir -pv "${HOME}/.local/share/fonts" && wget -O "${HOME}/.local/share/fonts/jetbrains-mono-nerd-font.ttf" 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/complete/JetBrains%20Mono%20NL%20Regular%20Nerd%20Font%20Complete.ttf?raw=true' && fc-cache -rv

# literation mono (LiterationMono Nerd Font)
mkdir -pv "${HOME}/.local/share/fonts" && wget -O "${HOME}/.local/share/fonts/literation-mono-nerd-font.ttf" 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/LiberationMono/complete/Literation%20Mono%20Nerd%20Font%20Complete.ttf?raw=true' && fc-cache -rv

# lazygit
sudo bash -c 'wget -O- https://github.com/jesseduffield/lazygit/releases/download/v0.35/lazygit_0.35_Linux_x86_64.tar.gz | tar xvz -C /usr/local/bin lazygit'

# micro
sudo bash -c 'pushd /usr/local/bin && curl https://getmic.ro | sh && popd'

# ncdu
sudo bash -c 'wget -O- https://dev.yorhel.nl/download/ncdu-2.2.1-linux-x86_64.tar.gz | tar xvz -C /usr/local/bin'

# rust
curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh -s -- -y --no-modify-path

# starship
sudo sh -c 'wget -O /tmp/starship.sh https://raw.githubusercontent.com/starship/starship/master/install/install.sh && sh /tmp/starship.sh -y' && starship preset plain-text-symbols > ~/.config/starship.toml

# telegram
sudo bash -c 'wget -O- https://telegram.org/dl/desktop/linux | tar xvJ -C /opt'

# yt-dlp
sudo bash -c 'wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && chmod +x /usr/local/bin/yt-dlp'
