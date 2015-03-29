#SingleInstance Force

/*
TSolidBackground
By Onurtag
https://bitbucket.org/Onurtag/tsolidbackground/

*/

winArr := Object()
OnExit, Exited
VarSetCapacity( APPBARDATA, 36, 0 )
bgcolor := 250000 
firsttime := 1
ProjectPage := " https://bitbucket.org/Onurtag/tsolidbackground"
Version := "v2"
TSolidBackgroundKey := "+t"
OnTopKey := "+y"
CenterKey := "+g"
TaskbarKey := "+f"
OptionsKey := "+o"
SuspendKey := "F8"
Menu, Tray, Icon,,, 1
Menu, Tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Reload, Reloaded
Menu, Tray, Add, Exit, Exited

IfExist, TSolidBackground.ini
{
	IniRead, bgcolor, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	IniRead, TSolidBackgroundKey, TSolidBackground.ini, TSolidBackground Settings, TSolidBackground Key 
	IniRead, OnTopKey, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniRead, CenterKey, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniRead, TaskbarKey, TSolidBackground.ini, TSolidBackground Settings, Show Hide Taskbar Key 
	IniRead, OptionsKey, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniRead, SuspendKey, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Hotkey, %OnTopKey%, +y
	Hotkey, %CenterKey%, +g
	Hotkey, %TaskbarKey%, +f
	Hotkey, %TSolidBackgroundKey%, +t
	Hotkey, %OptionsKey%, +o
	Hotkey, %SuspendKey%, F8
}

	Gui, start: Font, s12 cBlack bold
	Gui, start: Add, Text,, TSolidBackground %Version%
	Gui, start: Font, s10 cBlack norm
	Gui, start: Add, Text,, Current Hotkeys: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nOptions: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`n------------------------ `n`nMore info, Updates, `nAnd to learn how to change hotkeys check out the project page:
	Gui, start: Font, s10 cBlue underline
	Gui, start: Add, Text,gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, start: Font, s10 cBlack norm
	Gui, start: Add, Button, x168 y300 w64 h36 , Ok
	Gui, start: Show, h350 w400, Start TSolidBackground
Return

+y::
	WinGet, currentWindow, ID, A
	WinGetTitle, currentTitle, A
	addToWinArr(currentWindow)
	WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
	if (ExStyle & 0x8) { 
		Winset, AlwaysOnTop, off, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: OFF
	}
	else {
		WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: ON
	}
return

+o::
	SplashImage, OFF
	InputBox, bgcolor, Change Background Color, Enter a HEX color code. `nDefault value is: 250000 `n`nwww.colorpicker.com `nhtml-color-codes.info `n`nIf you press Ok TSolidBackground.ini file will be created. `nBy editing this file you can change hotkeys. `n`nFor more info go to project bitbucket page: `nbitbucket.org/onurtag/tsolidbackground,, 400, 310,,,,, 250000
	if ErrorLevel {
		return
	}
	if (bgcolor = "") {
		bgcolor := 250000 
	}
	IfNotExist, TSolidBackground.ini 
	{
		IniWrite, %ProjectPage%, TSolidBackground.ini, Help, #For help go to 
	}
	IniWrite, %bgcolor%, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	IniWrite, %TSolidBackgroundKey%, TSolidBackground.ini, TSolidBackground Settings, TSolidBackground Key 
	IniWrite, %OnTopKey%, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniWrite, %CenterKey%, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniWrite, %TaskbarKey%, TSolidBackground.ini, TSolidBackground Settings, Show Hide Taskbar Key 
	IniWrite, %OptionsKey%, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniWrite, %SuspendKey%, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Reload
return

+t::
	if (firsttime = 1) {
		Getactivewin()
		firsttime := 0
	}

	toggle := !toggle

	if (toggle = "1") {
	if (WinExist("A") != Activewin) {	
		Drawhud()
		Getactivewin()
		WinActivate, ahk_id %Activewin%
	}
		DrawBGGui()
	} 
	else {
		DestroyBGGui()
	}
return

+g::
	WinGetPos,,, WWWidth, HHHeight, A
    WinMove, A,, (A_ScreenWidth/2)-(WWWidth/2), (A_ScreenHeight/2)-(HHHeight/2)
	if (toggle = "1") {
		DrawBGGui()
	}
return

+f::
	TBtoggle := !TBtoggle

	if (TBtoggle = "1") {
		HideTaskbar()
	} 
	else {
		ShowTaskbar()
	}
Return

F8::
	Suspend
	if A_IsSuspended 
		Traytip, TSolidBackground, Suspended all other hotkeys. `nTo enable hotkeys press %SuspendKey%
	else
		Traytip, TSolidBackground, Enabled all hotkeys.
return

addToWinArr(chwnd) {
        global winArr
        if (!winArr.hasKey(chwnd))
			winArr[chwnd] := true
}

Abouted:
	Gui, about: Add, Text,, 
	Gui, about: Font, s14 cBlack
	Gui, about: Add, Text,, TSolidBackground %Version% by Onurtag
	Gui, about: Font, s10 cBlack
	Gui, about: Add, Text,, For Readme, Updates and more check out the project page:
	Gui, about: Font, s10 cBlue underline
	Gui, about: Add, Text, gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, about: Font, s10 cBlack norm
	Gui, about: Add, Button, x168 y170 w64 h36 , Ok
	Gui, about: Show, h225 w400, About TSolidBackground
Return

Getactivewin(){
	Global
	Activewin := WinExist("A")
	return
}

DrawBGGui(){
	Global
	WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	bg1FY := wY+Border_Size2+Caption_Size
	bg2FX := wX+Border_Size
	bg3SY := wY+HHeight-Border_Size2
	bg3H := A_ScreenHeight-bg3SY
	bg4SX := wX+WWidth-Border_Size
	bg4W := A_ScreenWidth-bg4SX
	
	Gui, +Disabled -Caption +Owner 
	Gui, Color, %bgcolor%
	Gui, bg1: +AlwaysOnTop -Caption +Owner 
	Gui, bg1: Color, %bgcolor%
	Gui, bg2: +AlwaysOnTop -Caption +Owner
	Gui, bg2: Color, %bgcolor%
	Gui, bg3: +AlwaysOnTop -Caption +Owner
	Gui, bg3: Color, %bgcolor%
	Gui, bg4: +AlwaysOnTop -Caption +Owner
	Gui, bg4: Color, %bgcolor%

	Gui, Show, NoActivate x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%
	Winset, Top,, ahk_id %Activewin%
	Gui, bg3: Show, NoActivate x0 y%bg3SY% h%bg3H% w%A_ScreenWidth%, TSolidBackground
	Gui, bg2: Show, NoActivate x0 y0 h%A_ScreenHeight% w%bg2FX%, TSolidBackground
	Gui, bg4: Show, NoActivate x%bg4SX% y0 h%A_ScreenHeight% w%bg4W%, TSolidBackground
	Gui, bg1: Show, NoActivate x0 y0 h%bg1FY% w%A_ScreenWidth%, TSolidBackground
	Sleep, 10
	Gui, Destroy
	return
}

Drawhud(){
	Gui, hud: +AlwaysOnTop -Caption +Owner +Border
	Gui, hud: Font, s11 cRed Bold Verdana
	Gui, hud: Add, Text,, Got new window for TSolidBackground
	Gui, hud: Show, NoActivate
	SetTimer, Deletehud, 1200
}

Deletehud:
	SetTimer, Deletehud, Off
	Gui, hud: Destroy
Return

DestroyBGGui(){
	Gui, bg1: Destroy
	Gui, bg2: Destroy
	Gui, bg3: Destroy
	Gui, bg4: Destroy
	Gui, Destroy
	return
}

GotoSite:
	Run, %A_GuiControl%
Return

aboutButtonOk:
startButtonOk:
	Gui, Destroy
return

HideTaskbar(){
	Global
	NumPut( ( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
	DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
	Sleep, 100
	WinHide, ahk_class Shell_TrayWnd
	WinHide, Start ahk_class Button
	return
}

ShowTaskbar(){
	Global
	NumPut( ( ABS_AUTOHIDE := 0x0 ), APPBARDATA, 32, "UInt" )
	DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
	Sleep, 50
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
	return
}

Reloaded:
	Reload
	Return

Exited:
	for currentWindow, b in winArr {
		Winset, AlwaysOnTop, off, ahk_id %currentWindow%
    }
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
	ExitApp
