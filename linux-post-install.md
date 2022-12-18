# APT

Minimal APT

```bash
cat << EOF | sudo tee /etc/apt/apt.conf.d/99-betterapt
// Disable translations
Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled false;
Acquire::Languages none;
// Disable phased updates
APT::Get::Never-Include-Phased-Updates true;
// Disable recommended packages
APT::Install-Recommends false;
// Disable sugggested packages
APT::Install-Suggests false;
EOF
```

Ubuntu Sources

```bash
cat << EOF
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu $(lsb_release -cs) partner
EOF
```

# Filesystem

```bash
sed '/^$/d;/^#/d' /etc/fstab | column -t
```

# GRUB2

```bash
sed '/^$/d;/^#/d' /etc/default/grub | sort
```

```bash
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

```bash
hostnamectl set-hostname starlabs
```

# Locale

```bash
localectl set-locale en_IN.UTF-8
```

```bash
sudo locale-gen en_IN.UTF-8
```

```bash
sudo update-locale en_IN.UTF-8
```

# Network

```bash
printf '[connection]\nwifi.powersave = 2\n' | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave-off.conf
```

# PopOS

APT

```bash
sudo cp -fv /etc/apt/sources.list.d/pop-os-apps.sources{,.bak}
```

```bash
sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources
```

Kernel

```bash
sudo kernelstub -vv -o 'ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer'
```

Flatpak

```bash
flatpak install org.gtk.Gtk3theme.Pop{,-light,-dark}
```

GNOME Settings

```bash
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
```

```bash
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop']"
```

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
```

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'
```

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '32'
```

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
```

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#211F1F'
```

```bash
gsettings set org.gnome.shell favorite-apps '["pop-cosmic-applications.desktop", "org.gnome.Nautilus.desktop", "google-chrome.desktop", "com.alacritty.Alacritty.desktop"]'
```

```bash
gsettings set com.system76.hidpi enable false
```

```bash
gsettings set com.system76.hidpi mode lodpi
```

```bash
gsettings set com.github.donadigo.eddy always-on-top true
```

```bash
gsettings set io.elementary.appcenter.settings automatic-updates false
```

# Startup

```bash
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

# Swappiness

```bash
printf '\nvm.swappiness = 10\n' | sudo tee /etc/sysctl.d/99-swappiness.conf
```

# Time

```bash
sudo apt-get install systemd-timesyncd
```

```bash
timedatectl set-timezone Asia/Kolkata
```

```bash
timedatectl set-ntp true
```

```bash
timedatectl set-local-rtc true
```

```bash
timedatectl --adjust-system-clock
```

```bash
timedatectl show
```
