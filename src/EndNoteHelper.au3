#include <GUIConstantsEx.au3>
#include <SendMessage.au3>
#include <WindowsConstants.au3>
#include <WinApi.au3>

HotKeySet("{PAUSE}", "terminate");
HotKeySet("{END}", "debug");

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

HotKeySet("{NUMPAD9}", "hotKeyPress");
HotKeySet("\", "hotKeyPress");

While 1
	Sleep(200)
WEnd

; Handle the hotkeys being pressed
; AutoIt cannot handle function parameters so this function takes the pressed keycode and works out where to redirect to
Func hotKeyPress()
	; Do not operate on non-EndNote windows (or non-list EndNote windows)
	; NOTE: (?i) indicates case insensitive from that point onwards unless its in a group
	if not StringRegExp(WinGetTitle("[ACTIVE]"), "^EndNote X7.*\.(?i)enl\]$") then
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
			
		case "{NUMPAD9}", "\"
			searchScholar()
			
		Case Else
			MsgBox(48, "EndNote Helper", "Unknown key sequence: " & @HotKeyPressed)
	EndSwitch
EndFunc

; Move the currently active reference to the group offset specified by $groupNo
Func moveToGroup($groupNo)
	Local $endNoteHwnd = WinGetHandle("[ACTIVE]")

	_SendMessage($endNoteHwnd, $WM_SETREDRAW, 0) ; Lock redrawing of the window to prevent flicker
	
	Send("!g") ; Open group menu
	Send("a") ; Skip down to "Add to Group" item
	Send("{DOWN}") ; Move down x1
	For $i = 1 To $groupNo
		Send("{DOWN}") ; Move down $groupNo times to the right group number
	Next
	Send("{ENTER}") ; Press Enter to confirm

	; BUGFIX: Hide + reshow the groups bar since EndNote doesn't update totals after a copy for some reason
	Send("!g")
	Send("h")
	Send("!g")
	Send("s")

	sleep(100)
	_SendMessage($endNoteHwnd, $WM_SETREDRAW, 1) ; Unlock redrawing of the window
	_WinAPI_RedrawWindow($endNoteHwnd, 0, 0, BitOr($RDW_ERASE, $RDW_FRAME, $RDW_INVALIDATE, $RDW_ALLCHILDREN)) ; Force total window repaint
EndFunc

Func searchScholar()
	Local $clip

	ClipPut("") ; Clear the clipboard so we know we can check against blanks
	Sleep(100) ; Wait for Clipboard to unlock (for some reason it takes time to do this)

	Send("^k") ; Copy ref to clipboard via EndNote

	; Keep asking the clipboard for contents until it returns non-null (only for 10 tries though)
	for $i = 1 to 10
		$clip = ClipGet() ; Extract copied reference from keyboard
		if ($clip <> "") Then ExitLoop
		Sleep(100) ; Sleep for 100ms
	Next
		
	if ($clip == "") Then
		MsgBox(16, "EndNote-Helper", "EndNote failed to provide a reference when asked. Maybe you don't have anything selected?")
	Else
		; Tidy up ref so its just the title
		Local $refExtracted = StringRegExpReplace($clip, '^.+"(.+?)".*', '$1')
		$refExtracted = StringRegExpReplace($refExtracted, '^\s+', '')
		$refExtracted = StringRegExpReplace($refExtracted, '\s+$', '')

		if ($refExtracted = "") Then
			MsgBox(16, "EndNote-Helper", "Sorry but I can't understand that reference format. Make sure 'Annotated' is selected as the reference format")
		Else
			; Make the ref URL ready
			Local $refExtractedURL = StringReplace($refExtracted, " ", "+")
			$refExtractedURL = StringRegExpReplace($refExtractedURL, "[\.]", "")
			
			ShellExecute("https://scholar.google.com/scholar?q=" & $refExtractedURL)
		EndIf
	EndIf	
EndFunc

Func debug()
	Local $output

	$output = "Active Window title is [" & WinGetTitle("[ACTIVE]") & "]" & Chr(10) & Chr(10)
		
	if StringRegExp(WinGetTitle("[ACTIVE]"), "^EndNote X7.*\.(?i)enl\]$") then
		$output &= "Which EndNote-Helper WILL handle"
	else
		$output &= "Which EndNote-Helper WILL NOT handle"
	EndIf 

	MsgBox(64, "EndNote-Helper", $output)
EndFunc

Func terminate()
	Exit
EndFunc