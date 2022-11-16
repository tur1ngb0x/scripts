@echo off
title windows-post-install.cmd
color 07

pause

:: browsers
powershell winget install --source winget --id Google.Chrome
powershell winget install --source winget --id Mozilla.Firefox

:: files
powershell winget install --source winget --id 7zip.7zip
powershell winget install --source winget --id voidtools.Everything

:: media
powershell winget install --source winget --id VideoLAN.VLC
powershell winget install --source winget --id DuongDieuPhap.ImageGlass

:: utilities
powershell winget install --source winget --id xanderfrangos.twinkletray
powershell winget install --source winget --id File-New-Project.EarTrumpet
powershell winget install --source winget --id Twilio.Authy
powershell winget install --source winget --id ProtonTechnologies.ProtonVPN
powershell winget install --source winget --id Bitwarden.Bitwarden

:: development
powershell winget install --source winget --id Microsoft.WindowsTerminal
powershell winget install --source winget --id Microsoft.PowerShell
powershell winget install --source winget --id Microsoft.VisualStudioCode
powershell winget install --source winget --id Git.Git

:: gaming
powershell winget install --source winget --id JeffreyPfau.mGBA
powershell winget install --source winget --id Valve.Steam
powershell winget install --source winget --id EpicGames.EpicGamesLauncher

:: directx
powershell invoke-webrequest -uri "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" -outfile "$HOME\Desktop\directx.exe"
powershell invoke-expression -command "$HOME\Desktop\directx.exe"

:: vcredist
powershell invoke-webrequest -uri 'https://github.com/abbodi1406/vcredist/releases/download/v0.62.0/VisualCppRedist_AIO_x86_x64_62.zip' -outfile "$HOME\AppData\Local\Temp\vcredist.zip"
powershell expand-archive -path "$HOME\AppData\Local\Temp\vcredist.zip" -DestinationPath "$HOME\Desktop"
powershell invoke-expression -command "$HOME\Desktop\VisualCppRedist_AIO_x86_x64.exe"

:: hostname
powershell rename-computer a5

:: hibernation
powershell powercfg /hibernate off

:: defender
powershell add-mppreference -exclusionpath "$HOME"

:: ssd
powershell optimize-volume -retrim -verbose -driveletter C

pause
