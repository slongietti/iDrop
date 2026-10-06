<#
.SYNOPSIS
    Saves the clipboard contents into the PhoneDrop folder.
.DESCRIPTION
    Target of the PhoneDrop hotkey. Copied files are copied over, an image is
    saved as a PNG, and text is saved as a .txt file. Shows a tray balloon
    with the result.
#>
param(
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\PhoneDrop')
)

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

function Show-Balloon([string] $Message) {
    $tray = New-Object System.Windows.Forms.NotifyIcon
    $tray.Icon = New-Object System.Drawing.Icon (Join-Path $PSScriptRoot 'phonedrop.ico')
    $tray.Visible = $true
    # ToolTipIcon None makes Windows show the tray icon (the Volare logo) in the notification.
    $tray.ShowBalloonTip(3000, 'PhoneDrop', $Message, [System.Windows.Forms.ToolTipIcon]::None)
    Start-Sleep -Seconds 4
    $tray.Dispose()
}

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

$stamp = Get-Date -Format 'yyyy-MM-dd HHmmss'
$files = Get-Clipboard -Format FileDropList
$image = Get-Clipboard -Format Image
$text = Get-Clipboard -Format Text -Raw

if ($files) {
    & (Join-Path $PSScriptRoot 'Send-ToPhoneDrop.ps1') -Folder $Folder -Path $files.FullName
    Show-Balloon "Sent $($files.Count) item(s) to PhoneDrop."
}
elseif ($image) {
    $image.Save((Join-Path $Folder "Clipboard $stamp.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose()
    Show-Balloon 'Sent clipboard image to PhoneDrop.'
}
elseif ($text) {
    Set-Content -LiteralPath (Join-Path $Folder "Clipboard $stamp.txt") -Value $text -Encoding UTF8
    Show-Balloon 'Sent clipboard text to PhoneDrop.'
}
else {
    Show-Balloon 'Clipboard is empty.'
}
