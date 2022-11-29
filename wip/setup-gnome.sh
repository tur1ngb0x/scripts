#!/usr/bin/env bash

# reset
#dconf reset -f /

# vanilla gnome
#sudo apt-get install --install-recommends -y gnome-session adwaita-icon-theme-full fonts-cantarell
#sudo update-alternatives --config gdm-theme.gresource

# gnome extras
#sudo apt-get install --install-recommends -y dconf-cli dconf-editor uuid-runtime
#sudo apt-get install --install-recommends -y gnome-shell-extensions gnome-shell-extension-prefs gnome-tweaks

# animations
gsettings set org.gnome.desktop.interface enable-animations false

# app grid
gsettings set org.gnome.shell app-picker-layout "[]"
gsettings set org.gnome.desktop.app-folders folder-children "[]"

# clock
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-format 24h

# extensions
gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color false

# fonts
gsettings set org.gnome.desktop.interface font-name 'Liberation Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Liberation Serif 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Liberation Bold 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'LiterationMono Nerd Font 11'
gsettings set org.gnome.desktop.interface font-hinting full
gsettings set org.gnome.desktop.interface font-antialiasing rgba
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0

# input
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# keybinds
gsettings set org.gnome.desktop.wm.keybindings close  "[]"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>t']"
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "[]"
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Shift><Super>r']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "[]"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>s']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "[]"
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "[]"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"

# lock screen
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

# power
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900

# removable media
gsettings set org.gnome.desktop.media-handling autorun-never true

# search
gsettings set org.gnome.desktop.search-providers disable-external true
gsettings set org.gnome.desktop.privacy remember-recent-files false

# sound
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.sound theme-name freedesktop

# theme
#gsettings set org.gnome.desktop.interface gtk-theme Adwaita
#gsettings set org.gnome.desktop.interface icon-theme Adwaita
#gsettings set org.gnome.desktop.interface cursor-theme Adwaita

# windows
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.mutter attach-modal-dialogs false
gsettings set org.gnome.mutter center-new-windows true
