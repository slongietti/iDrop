<#
.SYNOPSIS
    Saves the clipboard contents into the iDrop folder.
.DESCRIPTION
    Target of the iDrop hotkey. Copied files are copied over, an image is
    saved as a PNG, and text is saved as a .txt file. Shows a Windows
    notification with the result.
#>
param(
    [string] $Folder = (Join-Path $env:USERPROFILE 'iCloudDrive\iDrop')
)

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Registered by Install-iDrop.ps1 so the toast shows "iDrop" and the Volare icon.
$AppId = 'Volare.iDrop'

function Show-Toast([string] $Message) {
    [void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    [void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    $logo = [Uri]::new((Join-Path $PSScriptRoot 'idrop.png')).AbsoluteUri
    $text = [Security.SecurityElement]::Escape($Message)

    # The registered IconUri doesn't reliably reach the toast header, so the logo also goes in the body.
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>iDrop</text><text>$text</text><image placement='appLogoOverride' hint-crop='circle' src='$logo'/></binding></visual></toast>")
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show(
        [Windows.UI.Notifications.ToastNotification]::new($xml))
}

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

$stamp = Get-Date -Format 'yyyy-MM-dd HHmmss'
$files = Get-Clipboard -Format FileDropList
$image = Get-Clipboard -Format Image
$text = Get-Clipboard -Format Text -Raw

if ($files) {
    & (Join-Path $PSScriptRoot 'Send-ToiDrop.ps1') -Folder $Folder -Path $files.FullName
    Show-Toast "Sent $($files.Count) item(s) to iDrop."
}
elseif ($image) {
    $image.Save((Join-Path $Folder "Clipboard $stamp.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose()
    Show-Toast 'Sent clipboard image to iDrop.'
}
elseif ($text) {
    Set-Content -LiteralPath (Join-Path $Folder "Clipboard $stamp.txt") -Value $text -Encoding UTF8
    Show-Toast 'Sent clipboard text to iDrop.'
}
else {
    Show-Toast 'Clipboard is empty.'
}
