<!-- markdownlint-disable MD001 MD005 -->
<!-- markdownlint-disable MD001 MD014 -->
<!-- markdownlint-disable MD001 MD040 -->

# APT

```
$ cat << EOF | sudo tee /etc/apt/apt.conf.d/99-betterapt
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

$ cat << EOF
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu $(lsb_release -cs) partner
EOF
```

# Filesystem

```
$ mount | sed 's/ on / /' | sed 's/ type / /'| column -t

$ sed '/^$/d;/^#/d' /etc/fstab | column -t

$ sudo mount -o remount,uid=1000,gid=1000,rw /mnt/linuxdata
```

# GRUB2

```
$ sed '/^$/d;/^#/d' /etc/default/grub | sort

$ cat << EOF
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer"
GRUB_DISABLE_OS_PROBER="true"
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_SUBMENU="true"
GRUB_DISTRIBUTOR="Ubuntu"
GRUB_GFXPAYLOAD_LINUX="keep"
GRUB_TERMINAL_OUTPUT="console"
GRUB_TIMEOUT_STYLE="menu"
GRUB_TIMEOUT="10"
EOF
```

# Hostname

```
$ hostnamectl set-hostname starlabs

$ sudoedit /etc/hosts
```

# Locale

```
$ localectl set-locale en_IN.UTF-8

$ sudo locale-gen en_IN.UTF-8

$ sudo update-locale en_IN.UTF-8
```

# Network

```
$ sudo rm -fv /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

$ printf '[connection]\nwifi.powersave = 2\n' | sudo tee /etc/NetworkManager/conf.d/99-wifi-powersave-off.conf

$ sudo systemctl restart NetworkManager.service
```

# PopOS

```
$ sudo cp -fv /etc/apt/sources.list.d/pop-os-apps.sources{,.bak}

$ sudo sed -i 's/Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pop-os-apps.sources

$ sudo kernelstub -vv -o 'ipv6.disable=1 net.ifnames=0 nosgx nowatchdog pci=noaer'

$ flatpak install org.gtk.Gtk3theme.Pop{,-light,-dark}

$ gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

$ gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'

$ gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment 'START'

$ gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '32'

$ gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

$ gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#211F1F'

$ gsettings set org.gnome.shell favorite-apps '["pop-cosmic-applications.desktop", "org.gnome.Nautilus.desktop", "google-chrome.desktop", "com.alacritty.Alacritty.desktop"]'
```

# Startup Apps

```
$ sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

# Swappiness

```
$ printf 'vm.swappiness = 10\n' | sudo tee /etc/sysctl.d/99-swappiness.conf
```

# Time

```
$ timedatectl set-timezone Asia/Kolkata

$ timedatectl set-ntp true

$ timedatectl set-local-rtc true

$ timedatectl --adjust-system-clock

$ timedatectl show
```

# ZRAM
<!-- https://www.reddit.com/r/Fedora/comments/mzun99/new_zram_tuning_benchmarks/ -->

```
$ sudo mkdir -pv /etc/modules-load.d

$ printf 'zram\n' | sudo tee /etc/modules-load.d/zram.conf

$ sudo mkdir -pv /etc/modprobe.d

$ printf 'options zram num_devices=1\n' | sudo tee /etc/modprobe.d/zram.conf

$ sudo mkdir -pv /etc/udev/rules.d

$ printf 'KERNEL=="zram0", ATTR{disksize}="4096M", RUN="/usr/sbin/mkswap /dev/zram0", TAG+="systemd"\n' | sudo tee /etc/udev/rules.d/99-zram.rules

$ printf '\n\n/dev/zram0 none swap defaults 0 0\n\n' | sudo tee -a /etc/fstab

$ printf 'vm.swappiness = 200\n' | sudo tee /etc/sysctl.d/99-zram.conf

EOF
```
