# Windows 11 Search Speedup

**Is the search window on your Windows 11 taskbar slow to open?** This repo fixes it with a single-click `.bat` script.

![issue](https://img.shields.io/badge/issue-search_window_is_slow-red) ![fix](https://img.shields.io/badge/fix-one_click_.bat-brightgreen) ![os](https://img.shields.io/badge/OS-Windows_11-blue) ![license](https://img.shields.io/badge/license-MIT-blue)

---

## The Problem

When you click the search box on Windows 11 and wait **2-5 seconds** before the panel appears, the usual culprits are:

- **Web search integration** — waiting on Bing requests before rendering results
- **Search Highlights** — pulling dynamic content from Microsoft servers on every open
- **Corrupted SearchHost cache** — the local cache folder bloats / breaks over time
- **Cloud search (MSA/AAD)** — querying OneDrive, Outlook and other cloud sources
- **Menu animation delay** — Windows' default 400 ms menu fade-in

This script disables all of the above in one go.

---

## Usage

### Quick start

1. Download **[fix-search.bat](fix-search.bat)** from this repo
2. **Right-click → "Run as administrator"**
3. Press Enter and wait for it to finish (~10 seconds)
4. Click the search box and enjoy the speed

### To revert

Run **[undo-search.bat](undo-search.bat)** as administrator — every change is reverted to Windows defaults.

---

## What the Script Does

| Step | Action | Effect |
|---|---|---|
| 1 | `DisableSearchBoxSuggestions=1` | Disables web search suggestions |
| 2 | `BingSearchEnabled=0`, `CortanaConsent=0` | Disables Bing and Cortana |
| 2 | `ConnectedSearchUseWeb=0`, `AllowCortana=0` | Kills system-level web search |
| 2 | `IsMSACloudSearchEnabled=0`, `IsAADCloudSearchEnabled=0` | Disables cloud account search |
| 3 | `IsDynamicSearchBoxEnabled=0` | Disables Search Highlights |
| 3 | `ShowDynamicContent=0`, `AllowNewsAndInterests=0` | Stops dynamic content fetching |
| 4 | `MenuShowDelay=0` | Removes menu animation delay (400 ms → 0 ms) |
| 5 | Renames `Microsoft.BingSearch_8wekyb3d8bbwe` folder | Forces Windows to rebuild a clean cache |
| 6 | Restarts `WSearch`, `SearchHost.exe`, `explorer.exe` | Applies changes instantly |

### Registry paths modified

```
HKCU\Software\Policies\Microsoft\Windows\Explorer
HKCU\Software\Microsoft\Windows\CurrentVersion\Search
HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings
HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB
HKCU\Control Panel\Desktop
HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search
HKLM\SOFTWARE\Policies\Microsoft\Dsh
```

### Files backed up (not deleted)

```
%LOCALAPPDATA%\Packages\Microsoft.BingSearch_8wekyb3d8bbwe
  → Microsoft.BingSearch_8wekyb3d8bbwe.bak  (can be restored)
```

---

## FAQ

**Q: Will this damage my personal files?**
No. Only the Windows search box cache folder is renamed (not even deleted). Personal files, photos and documents are untouched.

**Q: Will Windows updates reset these settings?**
Some major feature updates may reset registry values. Just run the script again after the update.

**Q: It's still slow — what now?**
- Low RAM can cause this (≤4 GB)
- If you have an HDD, SearchHost is slow on cold start — an SSD upgrade helps a lot
- Try **Settings → Privacy → Searching Windows → Rebuild index**

**Q: Will I lose Cortana completely?**
No. The script **doesn't uninstall** Cortana — it just unbinds it from the search box. Cortana's standalone app keeps working (though it's invisible to most Windows 11 users anyway).

**Q: Does it work on Windows Home?**
Yes. It uses the registry directly instead of `gpedit.msc`, so it works on Home, Pro and Enterprise.

**Q: Does it work on Windows 10?**
It should work, but this was tested on Windows 11 only. The `Microsoft.BingSearch_8wekyb3d8bbwe` folder step may fail silently on Windows 10 (that's fine — the registry changes still apply).

---

## Security & Transparency

- The script is open source — read [fix-search.bat](fix-search.bat) and verify every command yourself
- Only documented Windows registry keys are changed
- **No files are deleted** (cache folder is renamed, fully reversible)
- **No network activity** — fully offline, no telemetry, nothing phones home

---

## Contributing

Found a bug or have a suggestion? **Open an Issue** or submit a **Pull Request**.

## License

[MIT](LICENSE)
