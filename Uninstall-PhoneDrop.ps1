<#
.SYNOPSIS
    Removes what Install-PhoneDrop.ps1 set up: the Send to shortcut, the
    clipboard hotkey shortcut, the cleanup scheduled task, and the
    notification app ID. Leaves the PhoneDrop folder and its files alone.
#>

Unregister-ScheduledTask -TaskName 'PhoneDrop Cleanup' -Confirm:$false -ErrorAction SilentlyContinue

Remove-Item -LiteralPath (Join-Path ([Environment]::GetFolderPath('SendTo')) 'iCloud PhoneDrop.lnk') -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path ([Environment]::GetFolderPath('Programs')) 'PhoneDrop Clipboard.lnk') -ErrorAction SilentlyContinue
Remove-Item -Path 'HKCU:\Software\Classes\AppUserModelId\Volare.PhoneDrop' -Recurse -ErrorAction SilentlyContinue

Write-Output 'PhoneDrop removed. The PhoneDrop folder in iCloud Drive was left in place.'
