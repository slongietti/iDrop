<#
.SYNOPSIS
    Copies files or folders into the iDrop folder.
.DESCRIPTION
    Target of the Explorer "Send to > iDrop" shortcut.
#>
[CmdletBinding(PositionalBinding = $false)]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Path,
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\iDrop')
)

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

foreach ($item in $Path) {
    $copy = Copy-Item -LiteralPath $item -Destination $Folder -Recurse -Force -PassThru |
        Select-Object -First 1
    # Copy-Item keeps the source's LastWriteTime; reset it so the cleanup clock starts now.
    $copy.LastWriteTime = Get-Date
}
