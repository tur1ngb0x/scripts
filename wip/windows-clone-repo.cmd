@echo off
title windows-clone-repo.cmd
color 07

pause

powershell invoke-webrequest -uri 'https://github.com/tur1ngb0x/stuff/archive/refs/heads/main.zip' -outfile "$HOME\Desktop\stuff-main.zip"
powershell expand-archive -path "$HOME\Desktop\stuff-main.zip" -DestinationPath "$HOME\Desktop"
powershell explorer "$HOME\Desktop\stuff-main"

pause
