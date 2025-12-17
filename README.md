# SkinningTracker

SkinningTracker is a lightweight addon for **World of Warcraft Classic Anniversary / Classic Era**.  
It helps you track your **skinning sessions** by recording time played, kills, skins, and a simple session log.

This addon is designed to be simple, clean, and easy to use.

---

## Features

- Track session time
- Count mob kills
- Count successful skinning actions
- Session log with timestamps
- Toggle UI with a slash command
- Movable frames
- Works on WoW Classic Anniversary / Classic Era

---

## Installation

1. Download or clone this repository
2. Copy the folder **SkinningTracker** into: World of Warcraft/classic_era/Interface/AddOns/
3. Make sure the folder contains:
   - `SkinningTracker.toc`
   - `SkinningTracker.lua`
4. Restart the game or reload the UI (`/reload`)
5. Enable the addon from the AddOns menu

---

## Usage

- Open / close the main window: /st


### Buttons

- **Start** – Start tracking the session
- **Stop** – Pause tracking
- **Reset** – Reset time, kills, skins, and log
- **Log** – Open or close the session log window

---

## Notes

- Tracking only works while the session is **started**
- Kills are counted when you get the killing blow
- Skinning is detected when the **Skinning** spell succeeds
- Closing the main window will also close the log window

---

## License

This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for details.
