# SCUM AHK Macros

A collection of useful [AutoHotKey](https://www.autohotkey.com/) macros for [SCUM](https://scumgame.com/) PC game.

You need [AutoHotKey](https://www.autohotkey.com/) installed (v1).

The following SCUM game macros were created by [neskk](mailto:neskk@neskk.com).

---

## Map Overlay - [map-overlay.ahk](map-overlay.ahk)

**Note**: Overlay maps are built for 1920x1080 game resolution.

### Show Map (M)

Press `M` hotkey to show a map overlay on top of ingame map.

You can edit the script to choose which map to show as overlay.

### Show Original Map (SHIFT+M)

Press `SHIFT+M` to show game map **without** the overlay.

---

## Drag 'n' Walk - [drag-walk.ahk](drag-walk.ahk)

**Note**: This macro can trigger attacks (left click).
**Avoid having a weapon in hands while using it.**

**Note 2**: This macro uses the mouse to pick up the **first** item from the vincinity. It then drags the item and places it in front of player's model.

### Drag Macro (CTRL+Q)

First open the inventory, then press `CTRL+Q` to start the mouse drag and drop loop, and you can start to walk.

To stop the macro you can:
- Press `Esc`
- Press `CTRL+Q` again

### Drag and Walk (CTRL+ALT+Q)

You just have to be around the item you want to move and press `CTRL+ALT+Q`.
The macro will set walking speed, start auto-walking, open the inventory and start the mouse drag and drop loop, and you can start to walk.

To stop the macro you can:
- Press `Esc`
- Press `S`
- Press `CTRL+Q`
- Press `CTRL+ALT+Q` again

### Terminate Script (CTRL+Z)

This is a "safety" kill switch to completly stop the script, in case something wrong is going on.

Press `CTRL+Z` to terminate the `drag-walk.ahk` script.

---

## Credits

The following libraries/resources are used in this project:
- [GDI+ standard library v1.45 by tic (Tariq Porter)](libs/Gdip_All.ahk)
- [Macro Recorder v2.1 By FeiYue](libs/Macro_Recorder.ahk)
- Maps from [SCUMDB.com](https://www.scumdb.com/)