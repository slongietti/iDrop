<#
.SYNOPSIS
    Removes what Install-iDrop.ps1 set up: the Send to shortcut, the
    clipboard hotkey shortcut, the cleanup scheduled task, and the
    notification app ID. Leaves the iDrop folder and its files alone.
#>

Unregister-ScheduledTask -TaskName 'iDrop Cleanup' -Confirm:$false -ErrorAction SilentlyContinue

Remove-Item -LiteralPath (Join-Path ([Environment]::GetFolderPath('SendTo')) 'iDrop.lnk') -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path ([Environment]::GetFolderPath('Programs')) 'iDrop Clipboard.lnk') -ErrorAction SilentlyContinue
Remove-Item -Path 'HKCU:\Software\Classes\AppUserModelId\Volare.iDrop' -Recurse -ErrorAction SilentlyContinue

Write-Output 'iDrop removed. The iDrop folder in iCloud Drive was left in place.'
