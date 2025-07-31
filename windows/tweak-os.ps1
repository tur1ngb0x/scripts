
function TimeZone {
    Start-Service -Name w32time -Wait
    Set-TimeZone -Id 'India Standard Time'
    Start-Process w32tm.exe -ArgumentList '/resync','/force' -NoNewWindow -Wait
}


function PowerManagement {
    # disable hibernate and fast startup
    powercfg /hibernate off
    # disable modern standby
    reg add "HKLM\System\CurrentControlSet\Control\Power" /v PlatformAoAcOverride /t REG_DWORD /d 0 /f
    # disable timeout on ac power
    powercfg /change monitor-timeout-ac 0
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
    powercfg /change disk-timeout-ac 0
}


function Explorer {
    # disable web search
    New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -PropertyType DWord -Value 1 -Force
    # enable classic context menus
    New-Item -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Force
    # open this pc
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Type DWord -Value 1 -Force
    # enable file extensions
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Type DWord -Value 0 -Force
    # enable hidden files
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Type DWord -Value 1 -Force
    # enable compact ui
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -Type DWord -Value 1 -Force
    # disable folder discovery
    Remove-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags' -Recurse -Force
    New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell' -Force
    New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell' -Name 'FolderType' -Value 'NotSpecified' -PropertyType String -Force
    # enable dark mode
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -PropertyType DWord -Value 0 -Force
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -PropertyType DWord -Value 0 -Force

}


function System {
    # enable long path support
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1 -Force
    # enable verbose status messages for login/logout
    New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'VerboseStatus' -PropertyType DWord -Value 1 -Force
    # set wallpaper quality to 100%
    New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'JPEGImportQuality' -PropertyType DWord -Value 100 -Force
    # add defender exclusion
    Add-MpPreference -ExclusionPath "$HOME\src"
    # Rename the computer to "windows"
    Rename-Computer -NewName 'windows' -Force
}


function Tasks {
    # compact os files
    compact.exe /CompactOS:Query
    compact.exe /CompactOS:Always
    # trim SSD
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
}

function Shortcuts {
    New-Item -ItemType Directory -Path "$HOME\Desktop" -Force *> $null
    $desktop = "$HOME\Desktop"
    $shell   = New-Object -ComObject WScript.Shell

    function local:lnk_wt {
        Remove-Item "$desktop\Terminal.lnk" -Force *> $null
        $shortcutPath          = Join-Path $desktop 'Terminal.lnk'
        $shortcut              = $shell.CreateShortcut($shortcutPath)
        $exePath                = Join-Path (Get-AppxPackage -Name Microsoft.WindowsTerminal)[-1].InstallLocation 'wt.exe'
        $shortcut.TargetPath   = $exePath
        $shortcut.IconLocation = "$exePath,0"
        $shortcut.Description  = 'Open Windows Terminal'
        $shortcut.Hotkey       = 'CTRL+ALT+T'
        $shortcut.WindowStyle  = 3
        $shortcut.Save()
        Write-Host "Shortcut created at $shortcutPath"
    }

    function local:lnk_ubuntu {
        Remove-Item "$desktop\Ubuntu.lnk" -Force *> $null
        $shortcutPath          = Join-Path $desktop 'Ubuntu.lnk'
        $shortcut              = $shell.CreateShortcut($shortcutPath)
        $exePath                = Join-Path (Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu24.04LTS)[-1].InstallLocation 'ubuntu2404.exe'
        $shortcut.TargetPath   = $exePath
        $shortcut.IconLocation = "$exePath,0"
        $shortcut.Arguments    = ''
        $shortcut.Description  = 'Open Ubuntu'
        $shortcut.Save()
        Write-Host "Shortcut created at $shortcutPath"
    }

    # call sub functions
    lnk_wt
    lnk_ubuntu
}; Shortcuts
