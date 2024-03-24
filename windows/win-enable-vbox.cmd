@echo off

echo Microsoft-Windows-Subsystem-Linux will be DISABLED.
echo VirtualMachinePlatform will be DISABLED.

pause

dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart

echo Machine will be restarted now, close window to skip restart

pause
shutdown.exe /f /t 0 /r
