#SingleInstance force

/*
By Onurtag
https://bitbucket.org/Onurtag/tsolidbackground/

*/

winArr := Object()
OnExit, Exited
VarSetCapacity( APPBARDATA, 36, 0 )
bgcolor := 250000 
BGKey := "+t"
OnTopKey := "+y"
CenterKey := "+g"
OptionsKey := "+o"
SuspendKey := "F8"
Menu, Tray, Icon,,, 1
Menu, tray, NoStandard
Menu, Tray, Add, About TSolidBackground, Abouted
Menu, Tray, Add, Reload, Reloaded
Menu, Tray, Add, Exit, Exited


IfExist, TSolidBackground.ini
{
	IniRead, bgcolor, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	IniRead, BGKey, TSolidBackground.ini, TSolidBackground Settings, Background Key 
	IniRead, OnTopKey, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniRead, CenterKey, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniRead, OptionsKey, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniRead, SuspendKey, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Hotkey, %OnTopKey%, +y
	Hotkey, %CenterKey%, +g
	Hotkey, %BGKey%, +t
	Hotkey, %OptionsKey%, +o
	Hotkey, %SuspendKey%, F8
	return
}

	Gui, Font, s12 cBlack bold
	Gui, Add, Text,, TSolidBackground v1.1 by Onurtag 
	Gui, Font, s10 cBlack norm
	Gui, Add, Text,, Current Hotkeys: `n------------------------`nTSolidBackground: %BGKey% `nAlways On Top: %OnTopKey% `nCenter Window: %CenterKey% `nOptions: %OptionsKey% `nSuspend other hotkeys: %SuspendKey% `n`nTo change hotkeys and more check readme in the link below
	Gui, Font, s10 cBlue underline
	Gui, Add, Text,gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, Font, s10 cBlack norm
	Gui, Add, Button, x168 y240 w64 h36 , Ok
	Gui, Show, h290 w400, Start TSolidBackground
Return
	
	
+y::
	WinGet, currentWindow, ID, A
	WinGetTitle, currentTitle, A
	addToWinArr(currentWindow)
	WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
	if (ExStyle & 0x8) {  ; 0x8 is WS_EX_TOPMOST.
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
	InputBox, bgcolor, Change Background Color, Enter a HEX color code without the '#'. `nDefault: 250000 `n`nwww.colorpicker.com `nhtml-color-codes.info
	if (bgcolor = "") {
		bgcolor := 250000 
	}
	if ErrorLevel {
		return
	}
	IniWrite, %bgcolor%, TSolidBackground.ini, TSolidBackground Settings, Background Color 
	IniWrite, %BGKey%, TSolidBackground.ini, TSolidBackground Settings, Background Key 
	IniWrite, %OnTopKey%, TSolidBackground.ini, TSolidBackground Settings, On Top Key 
	IniWrite, %CenterKey%, TSolidBackground.ini, TSolidBackground Settings, Center Window Key 
	IniWrite, %OptionsKey%, TSolidBackground.ini, TSolidBackground Settings, Options Key 
	IniWrite, %SuspendKey%, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Reload
return

+t::
	WinExist("ahk_class Shell_TrayWnd")

	toggle := !toggle

	if (toggle = "1") {
		NumPut( ( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		SplashImage,, a b CW%bgcolor% h%A_ScreenHeight% w%A_ScreenWidth%		;VirtualWidth and VirtualHeight instead of A_ScreenHeight and A_ScreenWidth gives you the total resolution of all monitors.
		Winset,Top,,A
		Sleep, 128
		WinHide, ahk_class Shell_TrayWnd
		WinHide, Start ahk_class Button
	} 
	else {
		NumPut( ( ABS_AUTOHIDE := 0x0 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		Sleep, 64
		WinShow, ahk_class Shell_TrayWnd
		WinShow, Start ahk_class Button
		SplashImage, OFF
	}
return


+g::
	WinGetPos,,, Width, Height, A
    WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return

	
F8::
	Suspend
	if A_IsSuspended 
		Traytip, TSolidBackground, Suspended other hotkeys. `nTo enable hotkeys press %SuspendKey%
	else
		Traytip, TSolidBackground, Enabled all hotkeys.
return


addToWinArr(chwnd) {
        global winArr
        if (!winArr.hasKey(chwnd))
			winArr[chwnd] := true
}


Abouted:
	Gui, Destroy
	Gui, Add, Text,, 
	Gui, Font, s14 cBlack
	Gui, Add, Text,, TSolidBackground v1.1 by Onurtag
	Gui, Font, s10 cBlack
	Gui, Add, Text,, Readme and Check for updates here:
	Gui, Font, s10 cBlue underline
	Gui, Add, Text,gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, Font, s14 cBlack norm
	Gui, Add, Button, x168 y170 w64 h36 , Ok
	Gui, Show, h225 w400, About TSolidBackground
Return


GotoSite:
	Run, %A_GuiControl%
Return

GuiClose:
ButtonOk:
	Gui, Destroy
return

Reloaded:
	Reload
return


Exited:
        for currentWindow, b in winArr {
			Winset, AlwaysOnTop, off, ahk_id %currentWindow%
        }
		WinShow, ahk_class Shell_TrayWnd
		WinShow, Start ahk_class Button
        ExitApp
