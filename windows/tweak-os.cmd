rem windows - set timezone and sync time
net stop w32time
net start w32time
tzutil /s "india standard time"
w32tm /resync /force

rem windows - disable timeout on ac power
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change disk-timeout-ac 0

rem windows - disable hibernation and fast startup
powercfg /hibernate off

rem file explorer - enable this pc
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f

rem file explorer - disable folder discovery
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f

rem file explorer - enable file extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f

rem file explorer - enable hidden files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f

rem file explorer - enable compact ui
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f 

rem start menu - disable web search
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f

rem explorer - enable classic context menus
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

rem explorer - set wallpaper quality to 100%
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f

rem explorer - dark mode
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f

rem defender - exclude paths
powershell.exe add-mppreference -exclusionpath $HOME/src

rem windows - enable verbose messages during login/logout
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f

rem windows - set hostname
powershell.exe rename-computer windows

rem windows - trim c drive
powershell.exe optimize-volume -retrim -verbose -driveletter C

rem windows - enable compact os
compact /compactos:query
compact /compactos:always
