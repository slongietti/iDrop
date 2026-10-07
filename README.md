# iDrop

Send screenshots and files from a Windows PC to an iPhone in a couple of
seconds, ready to drop into iMessage.

```
PC:     copy or capture  →  Ctrl+Alt+P  (or right-click → Send to → iDrop)
          ↓  iCloud Drive syncs the iDrop folder
iPhone: double-tap the back of the phone  →  picture is in Photos
          ↓
iMessage: + → Photos → it's the newest picture
```

The iDrop folder is a holding area, not storage: anything in it is deleted
after 15 minutes, and the iPhone shortcut clears out images once it has saved
them to Photos.

## What you need

- Windows 10 or 11
- An iPhone and an Apple ID
- Enough iCloud storage for a few screenshots at a time (the free 5 GB is plenty)

---

## Part 1: Set up the PC

### 1. Install iCloud for Windows

Install **iCloud** from the Microsoft Store, or run this in PowerShell:

```powershell
winget install 9PKTQ5699M62 --source msstore
```

### 2. Sign in and turn on iCloud Drive

1. Open the **iCloud** app and sign in with your Apple ID. Approve the sign-in
   on your iPhone if it asks.
2. Turn on **iCloud Drive**. Photos and the other options can stay off.
3. Check that the folder `C:\Users\<you>\iCloudDrive` now exists in File
   Explorer. Don't move on until it does: the installer would otherwise create
   a plain folder in that spot, which can clash with iCloud's own setup.

### 3. Get the scripts

Either clone the repo:

```powershell
git clone https://github.com/slongietti/iDrop.git C:\iDrop
```

or download it as a ZIP (**Code → Download ZIP** on GitHub) and extract it, for
example to `C:\iDrop`.

Keep the folder where it is after installing. The shortcuts and the cleanup
task point at it. If you move it later, run the installer again.

### 4. Run the installer

Open PowerShell and run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\iDrop\Install-iDrop.ps1
```

You should see:

```
iDrop ready: C:\Users\<you>\iCloudDrive\iDrop (cleanup every 5 min, max age 15 min, clipboard hotkey Ctrl+Alt+P)
```

The installer sets up:

| Piece | What it does |
|---|---|
| `iCloudDrive\iDrop` folder | The folder that syncs to the phone |
| **Send to → iDrop** | Right-click any file or folder to send it |
| **Ctrl+Alt+P** hotkey | Sends whatever is on the clipboard (Start Menu shortcut "iDrop Clipboard") |
| **iDrop Cleanup** scheduled task | Every 5 minutes, deletes anything in iDrop older than 15 minutes |
| `Volare.iDrop` notification ID | Makes the hotkey's notifications show "iDrop" and the Volare icon |

To change the defaults, pass them to the installer:

```powershell
powershell -ExecutionPolicy Bypass -File C:\iDrop\Install-iDrop.ps1 -MaxAgeMinutes 30 -Hotkey 'Ctrl+Alt+D'
```

| Parameter | Default |
|---|---|
| `-Folder` | `%USERPROFILE%\iCloudDrive\iDrop` |
| `-MaxAgeMinutes` | `15` |
| `-IntervalMinutes` | `5` (how often the cleanup runs) |
| `-Hotkey` | `Ctrl+Alt+P` |

### 5. Try it on the PC

1. Press **Win+Shift+S**, capture part of the screen, then press **Ctrl+Alt+P**.
2. A **iDrop** notification confirms the send.
3. Open `iCloudDrive\iDrop` in File Explorer. The capture is there as
   `Clipboard <date> <time>.png`.

---

## Part 2: Set up the iPhone

### 1. Find the iDrop folder

1. Open the **Files** app → **Browse** → **iCloud Drive** → **iDrop**. It
   can take a minute to appear after the PC install.
2. Long-press the **iDrop** folder → **Favorite**, so it's in the sidebar.

### 2. Create the iDrop album

Open **Photos** → **Albums** → **+** → **New Album** and name it `iDrop`.

### 3. Add the "iDrop to Photos" shortcut

The shortcut copies every image in iDrop into the iDrop album, then
deletes those images from the folder. Other files (PDFs, text) stay in the
folder for you to send from the Files app.

**Option A: add the ready-made shortcut (easiest)**

1. On the iPhone, open this link: **[iDrop to Photos](SHORTCUT_LINK)**
2. Tap **Add Shortcut**.
3. Open the shortcut in the **Shortcuts** app and check the first action. If
   it doesn't point at your iDrop folder, tap the folder name and choose
   **iCloud Drive → iDrop**.
4. Check that the **Save to Photo Album** action is set to **iDrop**.

**Option B: build it yourself**

In the **Shortcuts** app, tap **+** and rename the shortcut
**iDrop to Photos**. Then add these four actions in order (use the search
box under **Add Action**):

1. **Get Contents of Folder**: tap **Folder** → **iCloud Drive** →
   **iDrop** → **Open**.
2. **Filter Files**:
   - Tap **Add Filter** and set it to **File Extension** · **is** · `png`.
   - Add three more filters: **File Extension is** `jpg`, `jpeg`, and `heic`.
   - Above the filters, change **All** to **Any**.
3. **Save to Photo Album**: tap **Recents** and choose **iDrop**.
4. **Delete Files**:
   - It fills in **Saved Photo Media** on its own. **Change it.** Left as is,
     it points at the copies you just saved to Photos.
   - Tap **Saved Photo Media** → **Clear**, then tap the empty field →
     **Select Variable** → tap the **Files** output of **Filter Files**.
   - Turn **Delete Immediately** on, so cleared files don't pile up in
     Files → Recently Deleted for 30 days.

The finished shortcut reads:

```
Get Contents of Folder   iDrop
Filter Files             Any of: File Extension is png / jpg / jpeg / heic
Save to Photo Album      iDrop
Delete Files             Files (from Filter Files), Delete Immediately on
```

### 4. Run it once

Tap **▶︎** to run the shortcut. iOS asks for permission to access Files and
Photos. Allow both, and choose **Always Allow** if offered so later runs don't
prompt.

### 5. Set up Back Tap

1. Open **Settings** → **Accessibility** → **Touch** → **Back Tap**.
2. Choose **Double Tap** (or **Triple Tap**).
3. Scroll down to the **Shortcuts** section and pick **iDrop to Photos**.

Double-tapping the back of the phone now runs the shortcut. You can also add
it to the Home Screen: in the Shortcuts app, long-press it → **Share** →
**Add to Home Screen**.

---

## Daily use

**Send from the PC**

| You want to send | Do this |
|---|---|
| A screenshot | **Win+Shift+S** (or Snagit's **Copy**), then **Ctrl+Alt+P** |
| An image from a web page | Right-click → **Copy image**, then **Ctrl+Alt+P** |
| Any file or folder | Right-click it → **Send to** → **iDrop**. On Windows 11, **Send to** is under **Show more options** (or Shift+right-click) |
| Files you copied in Explorer | **Ctrl+C**, then **Ctrl+Alt+P** |
| Text | Copy it, then **Ctrl+Alt+P** (saved as a `.txt` file) |

**Use it on the iPhone**

- **Pictures:** double-tap the back of the phone, then in iMessage tap **+** →
  **Photos**. The picture is the newest one.
- **Other files:** Files → iDrop → long-press the file → **Share** →
  **Messages**, or **Copy** and paste it into the message.

Pictures saved to Photos stay there until you delete them. Only the copies in
the iDrop folder are cleaned up automatically.

## Troubleshooting

| Problem | Fix |
|---|---|
| Nothing shows up on the phone | Open the iCloud app on the PC and check that it's signed in with iCloud Drive on. On the phone, pull down to refresh in Files. |
| Ctrl+Alt+P does nothing | The first press after signing in can take a couple of seconds. If it never works, check that **iDrop Clipboard** exists in the Start Menu and re-run the installer. Another app may also be using that hotkey; reinstall with a different `-Hotkey`. |
| No **iDrop** in **Send to** | On Windows 11 it's under **Show more options**. Otherwise re-run the installer. |
| The notification shows the PowerShell icon | Re-run the installer. It registers the iDrop notification icon. |
| Files aren't being cleaned up | Open **Task Scheduler** and check **iDrop Cleanup**. It only runs while you're signed in to Windows. |
| The shortcut saves nothing | Check that the first action points at **iCloud Drive → iDrop** and that **Filter Files** is set to **Any**, not **All**. |

## How it works

| File | Purpose |
|---|---|
| `Install-iDrop.ps1` | Creates the folder, both shortcuts, the cleanup task, and the notification ID. Safe to re-run. |
| `Send-ToiDrop.ps1` | Copies files or folders into iDrop and resets their timestamp, so the 15 minutes start when you send. |
| `Send-ClipboardToiDrop.ps1` | Saves the clipboard into iDrop: copied files, an image as PNG, or text as `.txt`. |
| `iDropCleanup.ps1` | Deletes items in iDrop older than `-MaxAgeMinutes`. iCloud syncs the deletion to the phone. |
| `Uninstall-iDrop.ps1` | Removes the shortcuts, task, and notification ID. Leaves the iDrop folder alone. |
| `idrop.ico`, `idrop.png` | Volare icon for the shortcuts and notifications. |

## Uninstall

```powershell
powershell -ExecutionPolicy Bypass -File C:\iDrop\Uninstall-iDrop.ps1
```

Then delete the `iDrop` folder from iCloud Drive, and on the iPhone delete
the shortcut and turn off Back Tap if you no longer want them.
