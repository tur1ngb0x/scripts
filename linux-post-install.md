# APT
Minimal APT
```
cat << EOF | sudo tee /etc/apt/apt.conf.d/99-betterapt
Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;
Acquire::Languages "none";
APT::Get::Never-Include-Phased-Updates "true";
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF
```

Ubuntu Sources
```
cat << EOF
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu $(lsb_release -cs) partner
EOF
```

# Filesystem
```
sed '/^$/d;/^#/d' /etc/fstab | column -t
```

# GRUB2
```
sed '/^$/d;/^#/d' /etc/default/grub | sort
```

```
cat << EOF
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer"
GRUB_DISABLE_OS_PROBER="true"
GRUB_DISABLE_SUBMENU="true"
GRUB_DISTRIBUTOR="Ubuntu"
GRUB_TIMEOUT_STYLE="menu"
GRUB_TIMEOUT="5"
EOF
```

# Hostname
```
hostnamectl set-hostname starlabs
```

# Locale
```
localectl set-locale en_IN.UTF-8
```

```
sudo locale-gen en_IN.UTF-8
```

```
$ sudo update-locale en_IN.UTF-8
```

# Network
```
printf '[connection]\nwifi.powersave = 2\n' | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave-off.conf
```

# PopOS
```
sudo cp -fv /etc/apt/sources.list.d/pop-os-apps.sources{,.bak}
```

```
sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
```

```
sudo kernelstub -vv -o 'ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer'
```

```
flatpak install org.gtk.Gtk3theme.Pop{,-light,-dark}
```

```
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
```

```
gsettings set org.gnome.shell favourite-apps '['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop']'
```

```
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
```

```
gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'
```

```
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '32'
```

```
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
```

```
gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#211F1F'
```

```
gsettings set org.gnome.shell favorite-apps '["org.gnome.Nautilus.desktop", "org.gnome.Terminal.desktop", "google-chrome.desktop"]'
```

# Startup
```
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

# Swappiness
```
printf '\nvm.swappiness = 10\n' | sudo tee /etc/sysctl.d/99-swappiness.conf
```

# Time
```
sudo apt-get install systemd-timesyncd
```

```
timedatectl set-timezone Asia/Kolkata
```

```
timedatectl set-ntp true
```

```
timedatectl set-local-rtc true
```

```
timedatectl --adjust-system-clock
```

```
timedatectl show
```
