#!/usr/bin/env bash

# tested and working on
# ubuntu 22.04 jammy (plasmashell 5.24)
# debian 11 buster (plasmashell 5.20)

install_packages(){
	printf '\n\n\n\n\ninstalling packages...\n'
	packages=(i3-wm picom dmenu feh fonts-jetbrains-mono fonts-inter)
	for i in "${packages[@]}"; do sudo apt-get install --no-install-recommends --assume-yes "${i}"; done
}

create_session(){
	printf '\n\n\n\n\ncreating session...\n'
	cat <<-'EOF' | sudo tee /usr/share/xsessions/i3plasma.desktop
	[Desktop Entry]
	Type=XSession
	Name=i3plasma
	DesktopNames=KDE
	Exec=env KDEWM=/usr/bin/i3 /usr/bin/startplasma-x11
	EOF
}

create_service(){
	printf '\n\n\n\n\ncreating service...\n'
	cat <<-'EOF' | tee ~/.config/systemd/user/i3plasma.service
	[Install]
	WantedBy=plasma-workspace.target
	[Unit]
	Before=plasma-workspace.target
	Description=i3plasma.service
	[Service]
	ExecStart=/usr/bin/i3
	Restart=on-failure
	Slice=session.slice
	EOF
	systemctl --user mask plasma-kwin_x11.service
	systemctl --user daemon-reload
	systemctl --user enable i3plasma.service
}

create_config(){
	printf '\n\n\n\n\ncreating config...\n'
	rm -fv ~/.config/i3/config
	i3-config-wizard --modifier win
}

disable_settings(){
	printf '\n\n\n\n\ndisabling settings...\n'
	sed -i 's/^font pango/#font pango/g' ~/.config/i3/config
	sed -i 's/^exec --no-startup-id xss-lock/#exec --no-startup-id xss-lock/g' ~/.config/i3/config
	sed -i 's/^exec --no-startup-id nm-applet/#exec --no-startup-id nm-applet/g' ~/.config/i3/config
	sed -i 's/^bindsym XF86AudioRaiseVolume/#bindsym XF86AudioRaiseVolume/g' ~/.config/i3/config
	sed -i 's/^bindsym XF86AudioLowerVolume/#bindsym XF86AudioLowerVolume/g' ~/.config/i3/config
	sed -i 's/^bindsym XF86AudioMute/#bindsym XF86AudioMute/g' ~/.config/i3/config
	sed -i 's/^bindsym XF86AudioMicMute/#bindsym XF86AudioMicMute/g' ~/.config/i3/config
	sed -i 's/^bindsym $mod+d/#bindsym $mod+d/g' ~/.config/i3/config
	sed -i 's/^bindsym $mod+Shift+e/#bindsym $mod+Shift+e/g' ~/.config/i3/config
	#sed -i 's//#/g' ~/.config/i3/config
}

enable_settings(){
	printf '\n\n\n\n\nadding settings...\n'
	cat <<-'EOF' | tee -a ~/.config/i3/config
	font pango: Inter Medium 10
	bindsym $mod+d exec --no-startup-id i3-dmenu-desktop --dmenu="dmenu -i -p 'Apps:' -fn 'Inter Medium-10'"
	#bindsym $mod+d exec --no-startup-id qdbus org.kde.krunner /App display
	exec --no-startup-id /usr/lib/pam_kwallet_init
	exec_always --no-startup-id feh --bg-fill /usr/share/wallpapers/Next/contents/images/1920x1080.jpg
	exec_always --no-startup-id picom -bc
	focus_follows_mouse no
	focus_wrapping no
	hide_edge_borders none
	title_align center
	workspace_auto_back_and_forth no
	show_marks no
	#for_window [all] border pixel 0
	#for_window [all] title_window_icon padding 1px
	#for_window [all] title_format "<b>%title</b>"
	for_window [class="kinfocenter"] floating enable
	for_window [class="Klipper"] floating enable; border none
	for_window [class="Kmix"] floating enable; border none
	for_window [class="krunner"] floating enable; border none
	for_window [class="Plasma"] floating enable; border none
	for_window [class="plasmashell" window_type="notification"] floating enable, border none, move position 1450px 20px
	for_window [class="plasmashell"] floating enable
	for_window [class="Plasmoidviewer"] floating enable; border none
	for_window [class="systemsettings"] floating enable
	for_window [class="yakuake"] floating enable
	for_window [title="Bureau — Plasma"] kill, floating enable, border none
	for_window [title="Desktop — Plasma"] kill; floating enable; border none
	for_window [title="plasma-desktop"] floating enable; border none
	for_window [title="Save File — KDialog"] floating disable
	for_window [title="win7"] floating enable; border none
	for_window [window_role="About"] floating enable
	for_window [window_role="bubble"] floating enable
	for_window [window_role="pop-up"] floating enable
	for_window [window_role="Preferences"] floating enable
	for_window [window_role="task_dialog"] floating enable
	for_window [window_type="dialog"] floating enable
	for_window [window_type="menu"] floating enable
	no_focus [class="plasmashell" window_type="notification"]
	EOF
}

show_settings(){
	printf '\n\n\n\n\nshowing settings...\n'
	sed '/^$/d;/^\s*#/ d' ~/.config/i3/config
}

# for plasmashell < v5.25
install_packages && create_session && create_config; disable_settings && enable_settings && show_settings

# for plasmashell >= v5.25
#install_packages && create_service && create_config; disable_settings && enable_settings && show_settings
