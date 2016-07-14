#include <GUIConstantsEx.au3>

HotKeySet("{PAUSE}", "terminate");

HotKeySet("{SPACE}", "hotKeyPress");
HotKeySet("{NUMPAD1}", "hotKeyPress");
HotKeySet("1", "hotKeyPress");

HotKeySet("{LEFT}", "hotKeyPress");
HotKeySet("{NUMPAD2}", "hotKeyPress");
HotKeySet("2", "hotKeyPress");

HotKeySet("{RIGHT}", "hotKeyPress");
HotKeySet("{NUMPAD3}", "hotKeyPress");
HotKeySet("3", "hotKeyPress");

HotKeySet("{NUMPAD0}", "hotKeyPress");
HotKeySet("{NUMPAD4}", "hotKeyPress");
HotKeySet("4", "hotKeyPress");


While 1
	Sleep(200)
WEnd

; Handle the hotkeys being pressed
; AutoIt cannot handle function parameters so this function takes the pressed keycode and works out where to redirect to
Func hotKeyPress()
	; Do not operate on non-EndNote windows (or non-list EndNote windows)
	if not StringRegExp(WinGetTitle("[ACTIVE]"), "^EndNote X7.*\.enl\]$") then
		; Send the original space key since we hijacked it
		HotKeySet(@HotKeyPressed)
		Send(@HotKeyPressed)
		HotKeySet(@HotKeyPressed, "hotKeyPress");
		return 
	EndIf 

	Switch @HotKeyPressed
		Case "{SPACE}", "{NUMPAD1}", "1"
			moveToGroup(1)

		Case "{LEFT}", "{NUMPAD2}", "2"
			moveToGroup(2)

		Case "{RIGHT}", "{NUMPAD3}", "3"
			moveToGroup(3)

		Case "{NUMPAD0}", "{NUMPAD4}", "4"
			moveToGroup(4)
			
		Case Else
			MsgBox(48, "EndNote Helper", "Unknown key sequence: " & @HotKeyPressed)
	EndSwitch
EndFunc

; Move the currently active reference to the group offset specified by $groupNo
Func moveToGroup($groupNo)
	WinSetState(WinGetHandle("[ACTIVE]"), "", @SW_LOCK) ; Lock the window to prevent flicker
	
	Send("!g") ; Open group menu
	Send("a") ; Skip down to "Add to Group" item
	Send("{DOWN}") ; Move down x1
	For $i = 1 To $groupNo
		Send("{DOWN}") ; Move down $groupNo times to the right group number
	Next
	Send("{ENTER}") ; Press Enter to confirm
	Send("{DOWN}") ; Move to the next reference

	; BUGFIX: Hide + reshow the groups bar since EndNote doesn't update totals after a copy for some reason
	Send("!g")
	Send("h")
	Send("!g")
	Send("s")
	
	WinSetState(WinGetHandle("[ACTIVE]"), "", @SW_UNLOCK)
EndFunc

Func terminate()
	Exit
EndFunc