![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)

# HDI_SavePrintSettings

Saving and restoring a printer configuration by serialising the current print settings to a BLOB. Originally published by 4D as a **HDI** (*How Do I*) example for **4D v16**; converted from the binary `.4DB` to the `.4DProject` architecture so it runs on current 4D releases.

## What it demonstrates

- Capturing the current print settings into a BLOB with `Print settings to BLOB`.
- Restoring them later with `BLOB to print settings`, then continuing to print with those options.
- Displaying the page-setup dialog with `PRINT SETTINGS` so the user can change options between save and restore.
- Persisting the BLOB in a record so settings survive across sessions.
- Storing separate BLOBs per platform (`PrintSettingsMAC` / `PrintSettingsWIN`), because print settings are not portable between macOS and Windows.
- Interpreting the restore return code (printer changed, no printer, damaged settings) and optionally resetting copies/range with a modifier key.

## Key commands

| Command | Used for |
|---|---|
| `Print settings to BLOB` | Serialising the current print settings into a BLOB |
| `BLOB to print settings` | Restoring print settings from a saved BLOB, with a return code |
| `PRINT SETTINGS` | Showing the page-setup dialog to change the current settings |
| `BLOB size` | Checking whether the other platform's BLOB has been populated yet |

## How it works

The startup method `Project/Sources/Methods/00_Start.4dm` opens the standard `HDI` splash form; its `BtnDemo` object method opens the demo form `HDI2`.

`Project/Sources/Forms/HDI2/method.4dm` ensures the storage record exists: on `On Load` it creates one `[PARAMETERS]` record if the table is empty, then selects all records. The table (see `Project/Sources/catalog.4DCatalog`) holds two BLOB fields, `PrintSettingsMAC` and `PrintSettingsWIN`.

The demo walks through a numbered sequence, one button per step:

- `Button.4dm`, `Button4.4dm`, `Button6.4dm` -- each calls `PRINT SETTINGS` to open the page-setup dialog (steps #1, #3, #5).
- `Button1.4dm` (Save) -- `Print settings to BLOB($printSettings)`, then stores the BLOB into the field matching the running platform (`Is macOS`). If the other platform's BLOB is still empty (`BLOB size = 0`) it seeds it with the same data, then `SAVE RECORD`.
- `Button5.4dm` (Reload) -- reads the platform-matching BLOB and calls `BLOB to print settings`. With `Shift down` it passes the reset option so copies revert to 1 and range to all. It then branches on the return code and, on failure, falls back to `PRINT SETTINGS`.

Read `Button1.4dm` and `Button5.4dm` together -- they are the save/restore core; the other buttons just invoke the settings dialog.

## Points of interest

- Print settings are platform-specific. The demo deliberately keeps one BLOB per platform and, on first save, copies the current platform's BLOB into the other slot as a "better than nothing" placeholder.
- `BLOB to print settings` returns a status, not just success/failure: `1` OK, `2` printer changed, `0` no current printer, `-1` damaged/invalid BLOB -- the demo alerts on each.
- Holding Shift while reloading passes the optional argument to `BLOB to print settings` that resets the copy count and page range.
- The persisted record is created lazily on first form load, so the demo works on a fresh data file.

## Modernisation notes

Converted from the 4D v16 binary `.4DB` to the `.4DProject` architecture. The branch below carries the modernisation work.

| Branch | Description | Instructions |
|--------|-------------|--------------|
| [`miyako-hdi-migration-tasks`](../../tree/miyako-hdi-migration-tasks) | Full HDI modernisation (XLIFF, declarations, menu, method visibility, startup, dark mode CSS) | [localisation.instructions.md](.github/instructions/localisation.instructions.md), [variable.declarations.instructions.md](.github/instructions/variable.declarations.instructions.md), [menu.instructions.md](.github/instructions/menu.instructions.md), [method.visibility.instructions.md](.github/instructions/method.visibility.instructions.md), [startup.instructions.md](.github/instructions/startup.instructions.md), [css.instructions.md](.github/instructions/css.instructions.md), [tahoe.css.instructions.md](.github/instructions/tahoe.css.instructions.md) |

## References

- [4D blog: New commands to save and restore print settings](https://blog.4d.com/print-settings-blob-improvement/)
- [4D documentation: Print settings to BLOB](https://developer.4d.com/docs/commands/print-settings-to-blob)
- [4D documentation: BLOB to print settings](https://developer.4d.com/docs/commands/blob-to-print-settings)
- [4D documentation: PRINT SETTINGS](https://developer.4d.com/docs/commands/print-settings)
- Original download: [HDI_SavePrintSettings.zip](https://download.4d.com/Demos/4D_v16/HDI_SavePrintSettings.zip)
- Index of v16/v17 HDIs: [miyako/4d-hdi](https://github.com/miyako/4d-hdi)

## Screenshots

<img width="360" height="352" alt="Screenshot 2026-07-23 at 16 10 24" src="https://github.com/user-attachments/assets/bf9f8b89-02eb-4b30-9900-b7af1bf7c60a" />
<img width="760" height="592" alt="Screenshot 2026-07-23 at 16 11 15" src="https://github.com/user-attachments/assets/071b2ba5-b103-497e-83c4-8b911bb52686" />
