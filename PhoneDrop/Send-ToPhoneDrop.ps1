<#
.SYNOPSIS
    Copies files or folders into the PhoneDrop folder.
.DESCRIPTION
    Target of the Explorer "Send to > iCloud PhoneDrop" shortcut.
#>
param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]] $Path,
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\PhoneDrop')
)

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

foreach ($item in $Path) {
    $copy = Copy-Item -LiteralPath $item -Destination $Folder -Recurse -Force -PassThru |
        Select-Object -First 1
    # Copy-Item keeps the source's LastWriteTime; reset it so the cleanup clock starts now.
    $copy.LastWriteTime = Get-Date
}
