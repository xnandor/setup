#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; SetTitleMatchMode RegEx
SetTitleMatchMode Fast  ; Slow/Fast can be set independently of all the other modes.

;;HELP FROM ERIC
;;
;; To use:
;;	1. Install AutoHotkey.
;;	2. Place this script in your startup directory.
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GROUPS
GroupAdd, alreadyemacsgroup, ahk_exe bash.exe   	; already has emacs shortcuts
GroupAdd, alreadyemacsgroup, ahk_class SWT_Window0	;   eclipse main editor
GroupAdd, bashgroup, ahk_exe bash.exe           	; Bash
GroupAdd, cppbuildergroup, ahk_exe bds.exe      	; C++ Builder
GroupAdd, eclipsegroup, ahk_exe javaw.exe		; Eclipse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;VARIABLES
hackDelay := 100
keyDelay := 500
ctrlXPressed := 0
ctrlCPressed := 0
altXPressed := 0
altCPressed := 0
selectMode := 0
searchMode := 0

showStatus() {
	global
	local found := 0
	local statusString := ""
	local width := 60
	if (ctrlXPressed = 1) { 
		found := 1
		statusString := statusString . "   Ctrl-X"
		width := width + 30
	}
	if (ctrlCPressed = 1) { 
		found := 1
		statusString := statusString . "   Ctrl-C"
		width := width + 30
	}
	if (altXPressed = 1) { 
		found := 1
		statusString := statusString . "   Alt-X"
		width := width + 30
	}
	if (altCPressed = 1) { 
		found := 1
		statusString := statusString . "   Alt-C"
		width := width + 30
	}
	if (selectMode = 1) { 
		found := 1
		statusString := statusString . "   Select"
		width := width + 30
	}
	if (searchMode = 1) {
		found := 1
		statusString := statusString . "   Search"
		width := width + 30
	}
	if (found = 1) {
		Progress, bw%width%h20zh0x300y0fm8 fs8, %statusString%
	} else {
		Progress, Off
	}
}

searchModeOn() {
	global searchMode := 1
	showStatus()
}

searchModeOff() {
	global searchMode := 0
	showStatus()
}

selectModeOn() {
	global selectMode := 1
	showStatus()
}

selectModeOff() {
	global selectMode := 0
	showStatus()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Windows

                                      ;;;;close window
#w::
	send, !{F4}
return
#q::
	send, !{F4}
return


				      ;;;;Navigate Tabs
!+}::
	send, {Control down}{Tab}{Control up}
return

!+{::
	send, {Control down}{Shift down}{Tab}{Shift up}{Control up}
return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;AERO
^[::
	send, #^{Left}
return

^]::
	send, #^{Right}
return

;;;;snap left
^;::
	send, #{Left}
return  

;;;;snap right
^'::
	send, #{Right}
return

;;;;full screen
^,::
	send, #{Up}
return

                                      ;;;;suspend on double tap
Ctrl::
	Suspend, On
	sleep, keyDelay
	Suspend, Off
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EMACS
#IfWinNotActive, ahk_group alreadyemacsgroup
$^c::
	if (ctrlXPressed = 1) {
	} else if (ctrlCPressed = 1) {
		cppPressCC()
	} else if (selectMode = 1) {
	} else if (searchMode = 1) {
	} else {
		ctrlCPressed := 1
		showStatus()
		sleep, keyDelay
		ctrlCPressed := 0
		showStatus()
	}
return

$^x::
	ctrlXPressed := 1
	showStatus()
	sleep, keyDelay
	ctrlXPressed := 0
	showStatus()
return

$!c::
	altCPressed := 1
	showStatus()
	sleep, keyDelay
	altCPressed := 0
	showStatus()
return

$!x::
	altXPressed := 1
	showStatus()
	sleep, keyDelay
	altXPressed := 0
	showStatus()
return

^n::
	if (selectMode = 0) {
		send, {Down}
	} else {
		send, {Shift down}{Down}{Shift up}
	}
return

^p::
	if (selectMode = 0) {
		send, {Up}
	} else {
		send, {Shift down}{Up}{Shift up}
	}
return

^f::
	if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey < 300) {
	} if (ctrlXPressed = 1) {
		cppPressXF()
	} else if (ctrlCPressed = 1) {
	} else if (selectMode = 1) {
		send, {Shift down}{Right}{Shift up}
	} else if (searchMode = 1) {
	} else {
		send, {Right}
	}
return

^b::
	if (selectMode = 0) {
		send, {Left}
	} else {
		send, {Shift down}{Left}{Shift up}
	}
return

^a::
	if (selectMode = 0) {
		send, {Home}
	} else {
		send, {Shift down}{Home}{Shift up}
	}
return

^e::
	if (selectMode = 0) {
		send, {End}
	} else {
		send, {Shift down}{End}{Shift up}
	}
return

!n::
	if (selectMode = 0) {
		send, {Down 5}
	} else {
		send, {Shift down}
		send, {Down 5}
		send, {Shift up}
	}
return

!p::
	if (selectMode = 0) {
		send, {Up 5}
	} else {
		send, {Shift down}
		send, {Up 5}
		send, {Shift up}
	}
return


^d::
	if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey < 300) {
	} if (ctrlXPressed = 1) {
		cppPressXD()
	} else if (ctrlCPressed = 1) {
	} else if (selectMode = 1) {
	} else if (searchMode = 1) {
	} else {
		selectModeOff()
		send, {Delete}
	}

return

^k::
 	selectModeOff()
	send, {Shift down}
	send, {End}
	send, {Right}
	send, {Shift up}
	send, ^x
return

^Backspace::
	selectModeOff()
	send, {Shift down}
	send, {Home}
	send, ^x
	send, {Shift up}
return

^y::
	selectModeOff()
	send, ^v
return

^w::
	selectModeOff()
	send ^x
return

!w::
	send, ^c
return

^-::
	send, ^z
return

^i::
	send, {Tab}
return

!i::
	send, {Alt up}{Alt down}
	send, {Shift down}{Tab}{Shift up}
return

+!,::
	if (selectMode = 0) {
		send, ^{Home}
	} else {
		send, {Shift down}^{Home}{Shift up}
	}
return

+!.::
	if (selectMode = 0) {
		send, ^{End}
	} else {
		send, {Shift down}^{End}{Shift up}
	}
return

^space::
	if (selectMode = 0) {
		selectModeOn()
	} else {
		selectModeOff()
		send, {Left}{Right}
	}
return

^s::
	if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey < 300) {
	} if (ctrlXPressed = 1) {
		send, ^s
	} else if (ctrlCPressed = 1) {
	} else if (selectMode = 1) {
		cppPressSSelect()
	} else if (searchMode = 1) {
		cppPressSSearch()

	} else {
		cppPressS()
	}
return

^g::
	selectModeOff()
	searchModeOff()
	send, {ESC}{Left}{Right}
	showStatus()
return

$space::
	if (ctrlXPressed = 1) {
		send, {F5}
	} else {
		send, {space}
	}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;C++ BUILDER
#IfWinActive, ahk_group cppbuildergroup
!;::
               send, ^/
return

^-::
               send, ^z
return

cppPressXF() {
	send, ^{f12}
}

cppPressS() {
	searchModeOn()
       	send, ^e
	showStatus()
}

cppPressSSearch() {
        send, ^l
	showStatus()
}

cppPressSSelect() {
	exit
}

cppPressCC() {
	Send, {f9}
}

cppPressXD() {
	send, !{Up}
}

^r::
        If (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey < 300) {
        	Send, +^e ; Rename
        } else {
        	if (ctrlXPressed = 1) {
                	send, ^c
                        send, !^n
                        send, !^f
                        send, ^v
               } else {
               }
        }
return

^/::
               send, ^{space}
return

k::
               if (ctrlXPressed = 1) {
                              send, ^{F4}
               } else {
                              send, k
               }
return

b::
               if (ctrlXPressed = 1) {
                              send, ^{F6}
               } else {
                              send, b
               }
return


laterLabel:
               ctrlCPressed := 0
               showStatus()
return

!1::
               MouseMove, 900, 350
               Click
return

!2::
               send, !^{F11}
return

!3::
               send, {F11}
return

!4::
               send, +!{F11}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;WINDOWS BASH
#IfWinActive, ahk_group bashgroup
^space::
	send, {F8}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ECLIPSE
#IfWinActive, ahk_group eclipsegroup
^e::
	send, {End}
return




