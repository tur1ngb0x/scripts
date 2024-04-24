@echo off

title ENABLE VBOX

echo ------------------------------------------------------------------------
echo Oracle Virtualbox will be ENABLED.
echo Microsoft-Windows-Subsystem-Linux will be DISABLED.
echo VirtualMachinePlatform will be DISABLED.
echo ------------------------------------------------------------------------

pause

dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /all /norestart

echo ------------------------------------------------------------------------
echo Machine will be RESTARTED now, close window to SKIP restart.
echo ------------------------------------------------------------------------

pause

shutdown.exe /f /t 0 /r
