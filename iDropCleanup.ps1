<#
.SYNOPSIS
    Deletes items in the iDrop folder older than the given age.
.DESCRIPTION
    Runs from the "iDrop Cleanup" scheduled task. iCloud syncs the
    deletions, so the files also disappear from the iPhone.
#>
param(
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\iDrop'),
    [int] $MaxAgeMinutes = 15
)

if (-not (Test-Path -LiteralPath $Folder)) { return }

$cutoff = (Get-Date).AddMinutes(-$MaxAgeMinutes)

Get-ChildItem -LiteralPath $Folder -Force |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    Remove-Item -Recurse -Force
