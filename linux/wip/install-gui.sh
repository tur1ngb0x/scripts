#!/usr/bin/env bash

# directories
mkdir -pv "${HOME}"/Applications
mkdir -pv "${HOME}"/.local/bin
mkdir -pv "${HOME}"/.local/share/applications

gui_code() {
	[[ -f "${HOME}"/Applications/VSCode-linux-x64/bin/code ]] && echo "already installed ${HOME}/Applications/VSCode-linux-x64/bin/code" && return
	mkdir -pv "${HOME}"/Applications
	wget -4O- 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64' | tar -vxz -C "${HOME}"/Applications
	mkdir -pv "${HOME}"/.local/share/applications
	cat <<-EOF | tee "${HOME}"/.local/share/applications/code.desktop
	[Desktop Entry]
	Name=Visual Studio Code (User)
	Comment=Code Editing. Redefined.
	Exec=${HOME}/Applications/VSCode-linux-x64/bin/code --unity-launch %F
	Icon=${HOME}/Applications/VSCode-linux-x64/resources/app/resources/linux/code.png
	Type=Application
	StartupNotify=false
	StartupWMClass=Code
	Categories=TextEditor;Development;IDE;
	MimeType=text/plain;inode/directory;application/x-code-workspace;
	Keywords=vscode;
	EOF
	cat <<-EOF | tee "${HOME}"/.local/share/applications/code-url-handler.desktop
	[Desktop Entry]
	Name=Visual Studio Code - URL Handler
	Comment=Code Editing. Redefined.
	GenericName=Text Editor
	Exec=${HOME}/Applications/VSCode-linux-x64/bin/code --open-url %U
	Icon=${HOME}/Applications/VSCode-linux-x64/resources/app/resources/linux/code.png
	Type=Application
	NoDisplay=true
	StartupNotify=true
	Categories=Utility;TextEditor;Development;IDE;
	MimeType=x-scheme-handler/vscode;
	Keywords=vscode;
	EOF
	mkdir -pv "${HOME}"/.local/bin
	ln -fsv "${HOME}"/Applications/VSCode-linux-x64/bin/code "${HOME}"/.local/bin/code
	#mkdir -pv "${HOME}"/Applications/VSCode-linux-x64/data/tmp
}

gui_firefox() {
	[[ -f "${HOME}"/Applications/firefox/firefox ]] && echo "already installed: ${HOME}/Applications/firefox/firefox" && return
	mkdir -pv "${HOME}"/Applications
	wget -4O- 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' | tar -xvjC "${HOME}"/Applications
	mkdir -pv "${HOME}"/.local/bin
	ln -fsv "${HOME}"/Applications/firefox/firefox "${HOME}"/.local/bin/firefox
	mkdir -pv "${HOME}"/.local/share/applications
	wget -4O "${HOME}"/.local/share/applications/firefox.desktop 'https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop'
	sed -i "s|Name=Firefox Web Browser|Name=Firefox (User)|g" "${HOME}"/.local/share/applications/firefox.desktop
	sed -i "s|Exec=firefox %u|Exec=${HOME}/Applications/firefox/firefox %u|g" "${HOME}"/.local/share/applications/firefox.desktop
	sed -i "s|Icon=/opt/firefox/browser/chrome/icons/default/default128.png|Icon=${HOME}/Applications/firefox/browser/chrome/icons/default/default128.png|g" "${HOME}"/.local/share/applications/firefox.desktop
	cat << EOF
$(tput rev)Error: Arch Linux$(tput sgr0)
XPCOMGlueLoad error for file ${HOME}/Applications/firefox/libxul.so:
libdbus-glib-1.so.2: cannot open shared object file: No such file or directory
Couldn't load XPCOM.
$(tput rev)Fix:$(tput sgr0)
$ sudo pacman -S dbus-glib
EOF
}

gui_thunderbird() {
	[[ -f "${HOME}"/Applications/thunderbird/thunderbird ]] && echo "already installed: ${HOME}/Applications/thunderbird/thunderbird" && return
	mkdir -pv "${HOME}"/Applications
	wget -4O- 'https://download.mozilla.org/?product=thunderbird-latest-ssl&os=linux64&lang=en-US' | tar -xvjC "${HOME}"/Applications
	mkdir -pv "${HOME}"/.local/bin
	ln -fsv "${HOME}"/Applications/thunderbird/thunderbird "${HOME}"/.local/bin/thunderbird
	mkdir -pv "${HOME}"/.local/share/applications
	wget -4O "${HOME}"/.local/share/applications/thunderbird.desktop 'https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop'
	sed -i "s|Name=Thunderbird Mail|Name=Thunderbird (User)|g" "${HOME}"/.local/share/applications/thunderbird.desktop
	sed -i "s|Exec=thunderbird %u|Exec=${HOME}/Applications/thunderbird/thunderbird %u|g" "${HOME}"/.local/share/applications/thunderbird.desktop
	sed -i "s|Icon=/opt/thunderbird/chrome/icons/default/default128.png|Icon=${HOME}/Applications/thunderbird/chrome/icons/default/default128.png|g" "${HOME}"/.local/share/applications/thunderbird.desktop
}

gui_telegram()
{
	wget -4O- 'https://telegram.org/dl/desktop/linux' | tar -xvJ -C "${HOME}"/Applications && (nohup "${HOME}"/Applications/Telegram/Telegram &) &> /tmp/telegram.out
	wget -4O /tmp/telegram.tar.xz 'https://telegram.org/dl/desktop/linux'
	tar --file /tmp/telegram.tar.xz -vvv --extract --xz --directory "${HOME}"/Applications
	(nohup "${HOME}"/Applications/Telegram/Telegram &) &> /tmp/telegram.txt
}

gui_toolbox()
{
	wget -4O- 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA' | tar -xvz --strip-components=1 -C /tmp && (nohup /tmp/jetbrains-toolbox &) &> /tmp/jetbrains-toolbox.out
	wget -4O /tmp/toolbox.tar.gz 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA'
	tar --file /tmp/toolbox.tar.gz -vvv --extract --gzip --strip-components 1 --directory /tmp
	(nohup /tmp/jetbrains-toolbox &) &> /tmp/jetbrains-toolbox.txt
}

# begin script from here
gui_code
gui_firefox
gui_thunderbird
gui_telegram
gui_toolbox
