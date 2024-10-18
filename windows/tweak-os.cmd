
rem disable hibernation and fast startup
powercfg /hibernate off

rem set hostname
powershell.exe rename-computer windows

rem exclude path from defender
powershell.exe add-mppreference -exclusionpath $HOME/src

rem trim c drive
powershell.exe optimize-volume -retrim -verbose -driveletter C

rem set timezone and sync time
net stop w32time
net start w32time
tzutil /s "india standard time"
w32tm /resync /force


rem disable web search inside start menu
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f

rem enable file explorer inside this pc
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f

rem disable folder discovery inside file explorer
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f

rem enable file extensions inside file explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f

rem enable verbose messages during login/logout
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f

rem enable classic context menus inside windows
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

rem set wallpaper quality to 100%
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f

rem enable compact os inside windows
compact /compactos:query
compact /compactos:always
