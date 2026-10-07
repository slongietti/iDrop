<#
.SYNOPSIS
    Sets up PhoneDrop: the iCloud Drive folder, the Explorer "Send to"
    shortcut, and the cleanup scheduled task.
.DESCRIPTION
    Safe to re-run; every step overwrites its previous result.
#>
param(
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\PhoneDrop'),
    [int] $MaxAgeMinutes = 15,
    [int] $IntervalMinutes = 5,
    [string] $Hotkey = 'Ctrl+Alt+P'
)

$ErrorActionPreference = 'Stop'

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

$sendScript = Join-Path $PSScriptRoot 'Send-ToPhoneDrop.ps1'
$cleanupScript = Join-Path $PSScriptRoot 'PhoneDropCleanup.ps1'
$icon = Join-Path $PSScriptRoot 'phonedrop.ico'

$sendTo = [Environment]::GetFolderPath('SendTo')
$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $sendTo 'iCloud PhoneDrop.lnk'))
$shortcut.TargetPath = 'powershell.exe'
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$sendScript`" -Folder `"$Folder`""
$shortcut.IconLocation = $icon
$shortcut.WindowStyle = 7
$shortcut.Save()

# Explorer only honors shortcut hotkeys on .lnk files in the Start Menu or on the desktop.
$clipboardScript = Join-Path $PSScriptRoot 'Send-ClipboardToPhoneDrop.ps1'
$programs = [Environment]::GetFolderPath('Programs')
$hotkeyShortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $programs 'PhoneDrop Clipboard.lnk'))
$hotkeyShortcut.TargetPath = 'powershell.exe'
$hotkeyShortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$clipboardScript`" -Folder `"$Folder`""
$hotkeyShortcut.IconLocation = $icon
$hotkeyShortcut.WindowStyle = 7
$hotkeyShortcut.Hotkey = $Hotkey
$hotkeyShortcut.Save()

# Gives Send-ClipboardToPhoneDrop's toasts their own name and icon instead of PowerShell's.
$appIdKey = 'HKCU:\Software\Classes\AppUserModelId\Volare.PhoneDrop'
New-Item -Path $appIdKey -Force | Out-Null
Set-ItemProperty -Path $appIdKey -Name DisplayName -Value 'PhoneDrop'
Set-ItemProperty -Path $appIdKey -Name IconUri -Value (Join-Path $PSScriptRoot 'phonedrop.png')

# conhost --headless keeps the task from flashing a console window every run.
$action = New-ScheduledTaskAction -Execute 'conhost.exe' `
    -Argument "--headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$cleanupScript`" -Folder `"$Folder`" -MaxAgeMinutes $MaxAgeMinutes"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive

Register-ScheduledTask -TaskName 'PhoneDrop Cleanup' -Action $action -Trigger $trigger `
    -Settings $settings -Principal $principal -Force | Out-Null

Write-Output "PhoneDrop ready: $Folder (cleanup every $IntervalMinutes min, max age $MaxAgeMinutes min, clipboard hotkey $Hotkey)"
