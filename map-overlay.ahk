; Make a GUI from an existing image on disk.
; We are using PNG files since it can handle transparency.
; Author: neskk - 2020-11-30
;
; Thanks to tic (Tariq Porter) for his GDI+ Library
; ahkscript.org/boards/viewtopic.php?t=6517

/* UNNECESSARY
; Run this script with Admin permissions
If (!A_IsAdmin)
	Run *RunAs "%A_ScriptFullPath%"
*/

#SingleInstance, Force
#NoEnv
SetBatchLines, -1

; Comment if GDI+ is already in your standard library
#Include, libs/Gdip_All.ahk

; Start GDI+
If (!pToken := Gdip_Startup()) {
	MsgBox, 48, "GDI+ error!", "GDI+ failed to start. Please ensure you have GDI+ on your system"
}

; https://www.autohotkey.com/docs/commands/SetKeyDelay.htm
SetKeyDelay, 20, 30
; https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm
SetTitleMatchMode, 1
; https://www.autohotkey.com/docs/commands/CoordMode.htm
CoordMode, Mouse, Screen

OnExit, HandleExit

global windowName := "SCUM ahk_class UnrealWindow"

; Map to show on the overlay screen
;global mapImage := "maps/complete/map.png"
;global mapImage := "maps/complete/map-60.png"
global mapImage := "maps/complete/map-80.png"
global guiShown := 0
global mapShown := 0

; Create two layered windows (+E0x80000 : must be used for UpdateLayeredWindow to work!) that is always on top (+AlwaysOnTop), has no taskbar entry or caption.
Gui, mapGui: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs

; Get a handle to this window in order to update it later
windowHandler := WinExist()

Gosub, CheckWinActive
SetTimer, CheckWinActive, 100
guiShown = 1
Gui, mapGui: Show, NA ; show the overlay window

; Get bitmap from the map image
mapBitmap := Gdip_CreateBitmapFromFile(mapImage)

If (!mapBitmap) {
	MsgBox, 48, "File loading error!", "Could not load the specified image"
	ExitApp
}

; Get the width and height of the bitmap we have just created from file
mapWidth := Gdip_GetImageWidth(mapBitmap)
mapHeight := Gdip_GetImageHeight(mapBitmap)
hbm := CreateDIBSection(mapWidth, mapHeight)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
canvas := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(canvas, 7)
Gdip_DrawImage(canvas, mapBitmap, 0, 0, mapWidth, mapHeight, 0, 0, mapWidth, mapHeight)
UpdateLayeredWindow(windowHandler, hdc, 0, 0, mapWidth, mapHeight)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(canvas)
Gdip_DisposeImage(mapBitmap)

If (WinActive(windowName) and guiShown = 1) {
	guiShown = 0
	Gui, mapGui: Hide
}

Return

#IfWinActive SCUM ahk_class UnrealWindow

; press M to show the map overlay
m::
	If (guiShown = 1) {
		If (mapShown = 1) {
			Send, m
			mapShown = 0
		}
		Gui, mapGui: Hide
		guiShown = 0
	} Else {
		Gui, mapGui: Show, NA
		guiShown = 1
		If (mapShown = 0) {
			Send, m
			mapShown = 1
		}
	}
Return

; press CTRL+M to show game map
^m::
	mapShown := !mapShown
	If (guiShown = 1) {
		Gui, mapGui: Hide
		guiShown = 0
	}
	Send, m
Return

;##############################################################################
CheckWinActive:
	GuiControlGet, focused_control, focus

	If (!WinActive(windowName) and guiShown = 1) {
		Gui, mapGui: Hide
		guiShown = 0
	}
Return

;##############################################################################
HandleExit:
	; GDI+ may now be shutdown on exiting the program
	Gdip_Shutdown(pToken)
	ExitApp
Return
