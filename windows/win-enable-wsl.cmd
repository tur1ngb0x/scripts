@echo on

echo Microsoft-Windows-Subsystem-Linux will be ENABLED.
echo VirtualMachinePlatform will be ENABLED.

pause

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

echo Machine will be restarted now, close window to skip restart

pause
shutdown.exe /f /t 0 /r
