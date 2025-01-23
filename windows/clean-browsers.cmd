@echo off

echo This will close all running instances and erase user profiles of:
echo  - Brave Browser by Brave Software
echo  - Chrome Browser by Google
echo  - Edge Browser by Microsoft
echo  - Firefox Browser by Mozilla
echo Close window to cancel
pause >nul

rem Prompt for confirmation
echo Are you sure you want to delete all user profiles? (Y/N)
set /p confirm=
if /i "%confirm%" neq "Y" exit

rem brave
taskkill /f /t /im brave.exe
if exist "%HOMEPATH%\AppData\Local\BraveSoftware\Brave-Browser\User Data" (
    rmdir /s /q "%HOMEPATH%\AppData\Local\BraveSoftware\Brave-Browser\User Data"
) else (
    echo Brave Browser data directory not found.
)

rem google chrome
taskkill /f /t /im chrome.exe
if exist "%HOMEPATH%\AppData\Local\Google\Chrome\User Data" (
    rmdir /s /q "%HOMEPATH%\AppData\Local\Google\Chrome\User Data"
) else (
    echo Google Chrome data directory not found.
)

rem microsoft edge
taskkill /f /t /im msedge.exe
taskkill /f /t /im msedgewebview2.exe
if exist "%HOMEPATH%\AppData\Local\Microsoft\Edge\User Data" (
    rmdir /s /q "%HOMEPATH%\AppData\Local\Microsoft\Edge\User Data"
) else (
    echo Microsoft Edge data directory not found.
)

rem mozilla firefox
taskkill /f /t /im firefox.exe
if exist "%HOMEPATH%\AppData\Local\Mozilla\Firefox\Profiles" (
    rmdir /s /q "%HOMEPATH%\AppData\Local\Mozilla\Firefox\Profiles"
) else (
    echo Firefox Local Profiles directory not found.
)
if exist "%HOMEPATH%\AppData\Roaming\Mozilla\Firefox\Profiles" (
    rmdir /s /q "%HOMEPATH%\AppData\Roaming\Mozilla\Firefox\Profiles"
) else (
    echo Firefox Roaming Profiles directory not found.
)

echo Cleanup completed.
pause >nul
exit
