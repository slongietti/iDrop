# Scripts

Personal Windows utility scripts.

## PhoneDrop

Gets files from the PC to the iPhone through an iCloud Drive folder
(`iCloudDrive\PhoneDrop`). Anything in the folder is deleted after 15 minutes,
and iCloud syncs the deletion to the phone.

- `Install-PhoneDrop.ps1` creates the folder, the Explorer **Send to > iCloud
  PhoneDrop** shortcut, and the **PhoneDrop Cleanup** scheduled task (every
  5 minutes). Re-run it after moving the repo.
- `Send-ToPhoneDrop.ps1` copies files or folders into PhoneDrop.
- `Send-ClipboardToPhoneDrop.ps1` (hotkey **Ctrl+Alt+P**) saves the clipboard
  into PhoneDrop: copied files, an image as PNG, or text as `.txt`.
- `PhoneDropCleanup.ps1` deletes items older than `-MaxAgeMinutes`.

Snagit: set the capture preset's Share output to **File** (PNG, automatic
file name) pointing at the PhoneDrop folder.

On the iPhone: Files > iCloud Drive > PhoneDrop. Long-press a file >
Share > Messages, or Save Image to put it in Photos.
