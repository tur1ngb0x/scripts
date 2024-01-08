:: disable echo
@echo off

:: warning
echo.
echo.
echo Save your work. Close all windows.
echo.
echo.

:: pause before starting
pause

:: enable echo
@echo on

:: repair windows image
dism /online /cleanup-image /restorehealth /norestart

:: repair windows files
sfc /scannow

:: remove old windows updates
dism /online /cleanup-image /startcomponentcleanup /resetbase /norestart

:: perform disk cleanup
cleanmgr /verylowdisk /sageset:420
cleanmgr /verylowdisk /sagerun:420

:: trim c drive
defrag c: /optimize /printprogress /verbose

:: disable echo
@echo off

:: warning
echo.
echo.
echo Reboot immediately for changes to take effect.
echo.
echo.

:: pause before closing
pause
exit

:: :: unused commands
:: @echo off
:: echo.
:: @echo on
:: :: disable auto updates
:: reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f
:: :: write stdout
:: <command> >> %homedrive%%homepath%\Desktop\filename.txt
:: :: scan disk and fix disk
:: chkdsk.exe c: /scan /perf /r
:: chkdsk.exe d: /x /r
:: :: launch disk cleanup
:: cleanmgr /verylowdisk /sageset:420
:: cleanmgr /sageset:420
:: cleanmgr /verylowdisk /sagerun:420
:: :: open logs
:: explorer.exe %windir%\logs\cbs
:: explorer.exe %windir%\logs\dism
:: :: check if dirty bit is set
:: fsutil dirty query c:
:: :: trim ssd
:: powershell.exe optimize-volume -verbose -retrim -driveletter c
