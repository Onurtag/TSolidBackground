#SingleInstance Force

/*
TSolidBackground
By Onurtag
https://bitbucket.org/Onurtag/tsolidbackground/

If you have any good suggestions, feel free to contact me.
*/

winArr := Object()
OnExit, Exited
bgcolor := 051523 
firsttime := 1
ProjectPage := " https://bitbucket.org/Onurtag/tsolidbackground"
Version := "v2.1.4"
TSolidBackgroundKey := "+T"
OnTopKey := "+Y"
CenterKey := "+G"
TaskbarKey := "+F"
OptionsKey := "+O"
ResizeKey := "+U"
SuspendKey := "F8"
Hudtext := ""
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
	IniRead, ResizeKey, TSolidBackground.ini, TSolidBackground Settings, Resize Key 
	IniRead, SuspendKey, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Hotkey, %OnTopKey%, +Y
	Hotkey, %CenterKey%, +G
	Hotkey, %TaskbarKey%, +F
	Hotkey, %TSolidBackgroundKey%, +T
	Hotkey, %OptionsKey%, +O
	Hotkey, %ResizeKey%, +U
	Hotkey, %SuspendKey%, F8
}

	Gui, start: Color, 292929
	Gui, start: Font, s14 c836DFF bold
	Gui, start: Add, Text,, TSolidBackground %Version%
	Gui, start: Font, s10 c836DFF bold
	Gui, start: Add, Text, x18 y36 , By Onurtag
	Gui, start: Font, s10 cDCDCCC norm
	Gui, start: Add, Text,, Current Hotkeys: `n------------------------`nTSolidBackground: %TSolidBackgroundKey% `nAlways On Top: %OnTopKey% `nShow Hide Taskbar: %TaskbarKey% `nCenter Window: %CenterKey% `nResize Window: %ResizeKey% `nOptions: %OptionsKey% `nSuspend other hotkeys: %SuspendKey%`n------------------------ `nIf no hotkeys work on selected window, run TSolidBackground as admin.`n`nFor more info and updates check out the project page: `n(or maybe you want to change hotkeys and know nothing)
	Gui, start: Font, s10 c3257BF underline
	Gui, start: Add, Text, x18 gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, start: Font, s10 cBlack norm
	Gui, start: Add, Button, x223 y335 w64 h36 , Ok
	Gui, start: Show, h385 w510, Start TSolidBackground
Return

+Y::
	WinGet, currentWindow, ID, A
	WinGetTitle, currentTitle, A
	addToWinArr(currentWindow)
	WinGet, WindowExStyle, ExStyle, ahk_id %currentWindow%
	if (WindowExStyle & 0x8) { 
		Winset, AlwaysOnTop, off, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: OFF
	}
	else {
		WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
		TrayTip, Window [%currentTitle%], Always on top status: ON
	}
Return

+O::
	SplashImage, OFF
	InputBox, bgcolor, Change Background Color, Enter a HEX color code. `nDefault value is: 051523 `nA safer color suggested for casualfags is '250000'. `n`nIf you press Ok TSolidBackground.ini file will be created. `nBy editing this file you can change hotkeys. `n`nFor more info go to project bitbucket page: `nbitbucket.org/Onurtag/tsolidbackground,, 400, 270,,,,, 051523
	if ErrorLevel {
		Return
	}
	if (bgcolor = "") {
		bgcolor := 051523 
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
	IniWrite, %ResizeKey%, TSolidBackground.ini, TSolidBackground Settings, Resize Key 
	IniWrite, %SuspendKey%, TSolidBackground.ini, TSolidBackground Settings, Suspend Hotkeys Key 
	Reload
Return

+T::
	if (firsttime = 1) {
		Activewin := WinExist("A")
		firsttime := 0
	}

	toggle := !toggle

	if (toggle = "1") {
	if (WinExist("A") != Activewin) {	
		Drawhud("Got a new window for TSolidBackground.")
		Activewin := WinExist("A")
	}
		DrawBGGui()
	} 
	else {
		DestroyBGGui()
	}
Return

+G::
	WinGetPos,,, WWWidth, HHHeight, A
    WinMove, A,, (A_ScreenWidth/2)-(WWWidth/2), (A_ScreenHeight/2)-(HHHeight/2)
	if (toggle = "1") {
		DrawBGGui()
	}
Return

+F::
	if (TBtoggle = "") {
		VarSetCapacity( APPBARDATA, 36, 0 )
		NumPut( 36, APPBARDATA, 0, "UInt" ) 
		NumPut( WinExist( "ahk_class Shell_TrayWnd" ), APPBARDATA, 4, "UInt" ) 
		TBtoggle := 0
	} 

	if (TBtoggle = 0) {
		NumPut( ( ABS_ALWAYSONTOP := 0x2 )|( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		Sleep, 100
		WinHide, ahk_class Shell_TrayWnd
		WinHide, Start ahk_class Button
		Sleep, 500
		WinHide, ahk_class Shell_TrayWnd	;Might as well do these again. They bug a lot.
		WinHide, Start ahk_class Button
		TBtoggle := 1
	} 
	else {
		WinShow, ahk_class Shell_TrayWnd
		WinShow, Start ahk_class Button
		NumPut( ( ABS_ALWAYSONTOP := 0x2 ), APPBARDATA, 32, "UInt" )
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		Sleep, 100
		WinShow, ahk_class Shell_TrayWnd	;Might as well do these again. They bug a lot.
		WinShow, Start ahk_class Button
		DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
		TBtoggle := 0
	}
Return

+U::
	Gui, resize: Destroy
	if (WinExist("A") != TBResized) {	
		Drawhud("Got a new window to resize.")
		TBResized := WinExist("A")
		WinGetPos,X,Y,W,H,ahk_id %TBResized%
		Worig := W
		Horig := H
	}
	WinGetPos,X,Y,Wnew,Hnew,ahk_id %TBResized%
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	Hclient := Hnew - 2*Border_Size2 - Caption_Size
	Wclient := Wnew - 2*Border_Size
	Gui, resize: Destroy
	Gui, resize: Color, 292929
	Gui, resize: Font, s10 cDCDCCC norm
	Gui, resize: Add,Button,x130 y210 w50 h23 gResizenow,Resize
	Gui, resize: Add,Button,x220 y210 w50 h23,Cancel
	Gui, resize: Add,Text,x60 y30 h13,Original:
	Gui, resize: Add,Text,x60 y50 h13,Current:
	Gui, resize: Add,Text,x60 y70 h13,Client area:
	Gui, resize: Add,Text,x60 y90 h13,HD Client:
	Gui, resize: Add,Text,x60 y144,New Width:
	Gui, resize: Add,Text,x60 y164,New Height:
	Gui, resize: Font, s10 c836DFF norm
	Gui, resize: Add,Text,x150 y30 h13,W: %Worig%,  H: %Horig%
	Gui, resize: Add,Text,x150 y50 h13,W: %Wnew%,  H: %Hnew%
	Gui, resize: Add,Text,x150 y70 h13,W: %Wclient%,  H: %Hclient%
	for1280w := Round(1280/(Wclient/Hclient))
	editdefH := for1280w + 2*Border_Size2 + Caption_Size
	editdefW := 1280 + 2*Border_Size
	Gui, resize: Add,Text,x150 y90 h13,W: %editdefW%,  H: %editdefH%
	Gui, resize: Font, s10 c836DFF bold
	Gui, resize: Add,Edit,x140 y162 w70 h19 vHnew,%editdefH%
	Gui, resize: Add,Edit,x140 y142 w70 h19 vWnew,%editdefW%
	Gui, resize: Show,w400 h250 , Resize Window
Return


F8::
	Suspend
	if A_IsSuspended 
		Traytip, TSolidBackground, Suspended all other hotkeys. `nTo enable hotkeys press %SuspendKey%
	else
		Traytip, TSolidBackground, Enabled all hotkeys.
Return

/*
F11::
	ListVars
Return
*/

addToWinArr(chwnd) {
        global winArr
        if (!winArr.hasKey(chwnd))
			winArr[chwnd] := true
}

Abouted:
	Gui, about: Color, 292929
	Gui, about: Font, s14 c836DFF
	Gui, about: Add, Text,, TSolidBackground %Version% by Onurtag
	Gui, about: Font, s10 cDCDCCC
	Gui, about: Add, Text,, `nFor readme, updates and more check out the project page:  
	Gui, about: Font, s10 c3257BF underline
	Gui, about: Add, Text, gGotoSite, https://bitbucket.org/Onurtag/tsolidbackground
	Gui, about: Font, s10 cBlack norm
	Gui, about: Add, Button, x168 y170 w64 h36 , Ok
	Gui, about: Show, h225 w400, About TSolidBackground
Return


DrawBGGui(){
	Global
	WinGetPos, wX, wY, WWidth, HHeight, ahk_id %Activewin%
	SysGet, Border_Size, 32
	SysGet, Border_Size2, 33
	SysGet, Caption_Size, 4
	bg1FY := wY+Border_Size2+Caption_Size
	bg2FX := wX+Border_Size
	bg3SY := wY+HHeight-Border_Size2
	bg4SX := wX+WWidth-Border_Size
	
	WinGet, WinExStyle, ExStyle, ahk_id %Activewin%
	WinGet, WinStyle, Style, ahk_id %Activewin%
	if (WinExStyle & 0x8) { 
		WinGetTitle, currentTitle, ahk_id %Activewin%
		if (currentTitle != "Kagami") {		;VNR fix.
			Winset, AlwaysOnTop, off, ahk_id %Activewin%
			TrayTip, Window [%currentTitle%], Always on top status: OFF
		}
	}

	if ((WinStyle & 0x40000) = 0) {		;Unresizable window fix
		bg1FY -= 5
		bg2FX -= 5
		bg3SY += 5
		bg4SX += 5
	}
	
	bg3H := A_ScreenHeight-bg3SY
	bg4W := A_ScreenWidth-bg4SX
	
	Gui, +Disabled -Caption +ToolWindow
	Gui, Color, %bgcolor%
	Gui, bg1: +AlwaysOnTop -Caption +ToolWindow
	Gui, bg1: Color, %bgcolor%
	Gui, bg2: +AlwaysOnTop -Caption +ToolWindow
	Gui, bg2: Color, %bgcolor%
	Gui, bg3: +AlwaysOnTop -Caption +ToolWindow
	Gui, bg3: Color, %bgcolor%
	Gui, bg4: +AlwaysOnTop -Caption +ToolWindow
	Gui, bg4: Color, %bgcolor%
	Gui, Show, NoActivate x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%		;To hide the fact that I am using 4 GUIs
	Winset, Top,, ahk_id %Activewin%
	Gui, bg3: Show, NoActivate x0 y%bg3SY% h%bg3H% w%A_ScreenWidth%, TSolidBackground
	Gui, bg2: Show, NoActivate x0 y0 h%A_ScreenHeight% w%bg2FX%, TSolidBackground
	Gui, bg4: Show, NoActivate x%bg4SX% y0 h%A_ScreenHeight% w%bg4W%, TSolidBackground
	Gui, bg1: Show, NoActivate x0 y0 h%bg1FY% w%A_ScreenWidth%, TSolidBackground
	Sleep, 10
	Gui, Destroy
	Return
}

Drawhud(Hudtext){
	Gui, hud: +AlwaysOnTop -Caption +Border +ToolWindow
	Gui, hud: Color, 292929
	Gui, hud: Font, s11 cBF3232 Bold Verdana
	Gui, hud: Add, Text,, %Hudtext%
	Gui, hud: Show, NoActivate
	SetTimer, Deletehud, 1350
	Return
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
	Return
}

GotoSite:
	Run, %A_GuiControl%
Return

aboutButtonOk:
startButtonOk:
resizeButtonCancel:
	Gui, Destroy
Return

Resizenow:
	Gui, Submit
	WinMove,ahk_id %TBResized%,,,,%Wnew%,%Hnew%
Return	

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
