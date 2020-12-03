; This macro is for SCUM game and lets you drag chests while walking
; Author: neskk - 2020-12-01

/* UNNECESSARY
; Run this script with Admin permissions
If (!A_IsAdmin)
	Run *RunAs "%A_ScriptFullPath%"
*/

#SingleInstance, Force
#NoEnv
SetBatchLines, -1

; https://autohotkey.com/board/topic/50867-isDragging-with-loop-cant-break/
#MaxThreads 2
#MaxThreadsPerHotkey 2

; https://www.autohotkey.com/docs/commands/SetKeyDelay.htm
SetKeyDelay, 20, 30
; https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm
SetTitleMatchMode, 1
; https://www.autohotkey.com/docs/commands/CoordMode.htm
CoordMode, Mouse, Screen

global windowName := "SCUM ahk_class UnrealWindow"
global isDragging := 0
global isWalking := 0

;WinWait, %windowName%
;IfWinNotActive, %windowName%,, WinActivate, %windowName%

#IfWinActive SCUM ahk_class UnrealWindow

; press CTRL+Z to exit the script
^z::ExitApp

; press SHIFT+E to set running speed 
+e::
	Gosub, SetWalkSpeed
Return

; press CTRL+Q to start the drag loop
^q::
	isDragging := !isDragging
	Gosub, DragLoop
Return

; press CTRL+ALT+Q to start walk and drag
^!q::
	If (isDragging = 0) {
		isDragging = 1
		Gosub, StartWalking
		Gosub, DragLoop
	} Else {
		isDragging = 0
	}
Return

#If ; END IfWinActive

#If isWalking = 1
; press S to stop the macro
s::
	isDragging = 0
Return
#If ; END isWalking = 1

#If isDragging = 1
; press Esc to stop the macro
Esc::
	isDragging = 0
Return
#If ; END isDragging = 1

;##############################################################################
CheckWinActive:
	GuiControlGet, focused_control, focus

	If (!WinActive(windowName)) {
		isDragging = 0
	}
Return

;##############################################################################
SetWalkSpeed:
	Sleep, 300
	Send, {WheelDown 5}
	Sleep, 300
	Send, {WheelDown 5}
	Sleep, 300
	Send, {WheelUp 5}
return

;##############################################################################
StartWalking:
	isWalking = 1
	Random, t, 0, 50
	Gosub, SetWalkSpeed
	Sleep, 200+t
	Send, +w ; start auto-walking
	Sleep, 100+t
	Send, {Tab} ; open inventory
	Sleep, 200
Return

;##############################################################################
StopWalking:
	isWalking = 0
	Send, {Esc} ; close inventory
	Sleep 100
	Send, s ; stop auto-walking
Return

;##############################################################################
Drag:
	Random, w, 0, 80 ; random value added to mouse X coordinate
	Random, h, 0, 60 ; random value added to mouse Y coordinate
	Random, t, 0, 50 ; random value added sleep timers

	; Drag item from vincinity
	MouseClick, L, 510+w, 230+h,,, D

	Sleep, 140+t

	; Release item on the ground
	;MouseClick, L, 1120+w, 960+h,,, U ; bottom left side of player
	MouseClick, L, 830+w, 900+h,,, U ; in-front of player

	Sleep, 180+t
Return

;##############################################################################
DragLoop:
	Loop {
		Gosub, CheckWinActive
		If (!isDragging) {
			If (isWalking) {
				Gosub, StopWalking
			}
			;MsgBox, "Paused"
			;ToolTip, Drag Walk`nPaused
			Sleep 200
			Break
		}
		Gosub, Drag
	}
Return