@echo on

echo ------------------------------------------------------------------------
echo Microsoft-Windows-Subsystem-Linux will be ENABLED.
echo VirtualMachinePlatform will be ENABLED.
echo Oracle Virtualbox will be DISABLED.
echo ------------------------------------------------------------------------

pause

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

echo ------------------------------------------------------------------------
echo Machine will be restarted now, close window to skip restart
echo ------------------------------------------------------------------------

pause
shutdown.exe /f /t 0 /r
