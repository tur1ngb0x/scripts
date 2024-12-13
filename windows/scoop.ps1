
# https://scoop.sh/
# Quickstart

# Open a PowerShell terminal (version 5.1 or later) and from the PS C:\> prompt, run:

# $ Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# $ Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
# $ irm get.scoop.sh | iex

# Advanced Installation
# https://github.com/ScoopInstaller/Install#readme

# Custom Installation
# $ irm get.scoop.sh -outfile "$HOME\Desktop\scoop-installer.ps1"
# $ "$HOME\Desktop\scoop-installer.ps1" -ScoopDir 'C:\Applications\Scoop' -ScoopGlobalDir 'F:\GlobalScoopApps' -NoProxy

# scoop cleanup --all
# scoop cache rm --all
# scoop checkup
# scoop update --all
# scoop update --all --global

# $ scoop list | Select-Object Name,Version,Source | Sort-Object Source,Name
# $ scoop bucket list | Select-Object Name,Source | Sort-Object Source,Name

# $ scoop uninstall --purge

# versions
scoop bucket add versions
scoop install versions/innounp-unicode

# main
scoop bucket add main
scoop install main/dark
scoop install main/git
scoop install main/sudo
scoop install main/micro
scoop install main/7zip
scoop install main/adb
scoop install main/python

# extras
scoop bucket add extras
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
scoop bucket add games
scoop install games/epic-games-launcher
scoop install games/mgba
scoop install games/ps3-system-software
scoop install games/rpcs3
scoop install games/steam

# sysinternals
scoop bucket add sysinternals
scoop install sysinternals/autoruns

# java
scoop bucket add java
scoop install java/openjdk

# nonportable
scoop bucket add nonportable
scoop install nonportable/auto-dark-mode-np

# nirsoft
scoop bucket add nirsoft
scoop install nirsoft/batteryinfoview
scoop install nirsoft/networkusageview
