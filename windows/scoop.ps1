
# https://github.com/ScoopInstaller/Install#readme

# PS> set-executionpolicy -executionpolicy bypass -scope localmachine
# PS> new-item -path "$HOME\Apps\Scoop\Local" -itemtype directory -force
# PS> new-item -path "$HOME\Apps\Scoop\Global" -itemtype directory -force
# PS> new-item -path "$HOME\Apps\Scoop\Cache" -itemtype directory -force

# PS> irm get.scoop.sh -outfile "$HOME\Desktop\scoop-installer.ps1"
# PS> "$HOME\Desktop\scoop-installer.ps1" -ScoopDir "$HOME\Apps\Scoop\Local" -ScoopGlobalDir "$HOME\Apps\Scoop\Global" -ScoopCacheDir "$HOME\Apps\Scoop\Cache"

# scoop cleanup --all
# scoop cache rm --all
# scoop checkup
# scoop update --all
# scoop update --all --global

# $ scoop list | Select-Object Name,Version,Source | Sort-Object Source,Name
# $ scoop bucket list | Select-Object Name,Source | Sort-Object Source,Name

# $ scoop uninstall --purge


# buckets
# https://github.com/ScoopInstaller/Scoop/blob/master/buckets.json
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nirsoft
scoop bucket add sysinternals
scoop bucket add php
scoop bucket add nerd-fonts
scoop bucket add java
scoop bucket add games


# versions
scoop install versions/innounp-unicode

# main
scoop install main/dark
scoop install main/git
scoop install main/sudo
scoop install main/micro
scoop install main/7zip
scoop install main/adb
scoop install main/python

# extras
scoop install extras/bitwarden
scoop install extras/discord
scoop install extras/everything
scoop install extras/firefox
scoop install extras/firefox-pwa
scoop install extras/imageglass
scoop install extras/localsend
scoop install extras/qbittorrent
scoop install extras/sharex
scoop install extras/smplayer
scoop install extras/telegram
scoop install extras/vcredist2022
scoop install extras/vscode

# games
scoop install games/epic-games-launcher
scoop install games/mgba
scoop install games/ps3-system-software
scoop install games/rpcs3
scoop install games/steam

# sysinternals
scoop install sysinternals/autoruns

# java
scoop install java/openjdk

# nonportable
scoop install nonportable/auto-dark-mode-np

# nirsoft
scoop install nirsoft/batteryinfoview
scoop install nirsoft/networkusageview
