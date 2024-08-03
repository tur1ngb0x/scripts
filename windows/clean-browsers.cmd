@echo off

echo This will close all running instances and erase user profiles of:
echo  - Google Chrome
echo  - Microsoft Edge
echo  - Mozilla Firefox
echo Close window to cancel
pause

rem google chrome
taskkill /f /t /im chrome.exe
rmdir /s %HOMEPATH%\AppData\Local\Google\Chrome\

rem microsoft edge
taskkill /f /t /im msedge.exe
rmdir /s %HOMEPATH%\AppData\Local\Microsoft\Edge\

rem mozilla firefox
taskkill /f /t /im firefox.exe
rmdir /s %HOMEPATH%\AppData\Local\Mozilla\Firefox\
rmdir /s %HOMEPATH%\AppData\Roaming\Mozilla\Firefox\

pause
exit
