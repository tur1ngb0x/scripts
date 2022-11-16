flatpak --user override --reset
flatpak --user override --filesystem=~/.config/fontconfig
flatpak --user override --filesystem=~/.config/git


for app in ~/.var/app/*; do ln -s ~/.config/fontconfig "$app/config/fontconfig"; done
for app in ~/.var/app/*; do ln -s ~/.config/git "$app/config/git"; done
